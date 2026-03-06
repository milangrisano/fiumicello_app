import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_colors.dart';

import 'package:responsive_app/page/product_page/widget_product/product_grid.dart';
import 'package:responsive_app/page/product_page/widget_product/category_pills.dart';
import 'package:responsive_app/page/product_page/widget_product/product_swiper.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_app/models/landing_menu_item.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/products_provider.dart';
import 'package:responsive_app/models/product.dart';

// ─────────────────────────────────────────
// Orden fijo de categorías para pills y grid
// ─────────────────────────────────────────
const List<String> _fixedCategoryOrder = [
  'Pizzas',
  'Paninis',
  'Lasagnas',
  'Bebidas',
];

class LandingPage extends StatefulWidget {
  final String? category;
  const LandingPage({super.key, this.category});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late String _selectedCategory;
  bool _showGrid = true;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? '';
  }

  @override
  void didUpdateWidget(LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != null && widget.category != _selectedCategory) {
      _selectedCategory = widget.category!;
    }
  }

  /// Ordena las categorías según el orden fijo definido en _fixedCategoryOrder.
  /// Las categorías que no estén en el orden fijo se agregan al final.
  List<String> _sortCategories(Iterable<String> categories) {
    final catSet = categories.toSet();
    final List<String> sorted = [];

    // Primero las que están en el orden fijo
    for (final cat in _fixedCategoryOrder) {
      if (catSet.contains(cat)) {
        sorted.add(cat);
        catSet.remove(cat);
      }
    }
    // Luego cualquier categoría nueva del backend que no esté en el orden fijo
    sorted.addAll(catSet);
    return sorted;
  }

  List<String> get _displayCategories {
    final productsProvider = context.read<ProductsProvider>();
    if (productsProvider.products.isNotEmpty) {
      final rawCats = productsProvider.products.map((Product p) => p.category).toSet();
      final cats = _sortCategories(rawCats);

      // Auto-seleccionar la primera categoría si no hay ninguna seleccionada
      if (_selectedCategory.isEmpty && cats.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedCategory = cats.first;
            });
          }
        });
      }
      return cats;
    }

    return [];
  }

  /// Orden fijo para los tamaños de pizza
  static const List<String> _sizeOrder = ['Personal', 'Mediana', 'Grande'];

  /// Agrupa productos de tipo pizza por nombre y crea un solo LandingMenuItem con sizeVariants
  List<LandingMenuItem> _groupPizzaProducts(List<Product> pizzaProducts) {
    final Map<String, List<Product>> grouped = {};
    for (final p in pizzaProducts) {
      grouped.putIfAbsent(p.name, () => []).add(p);
    }

    final List<LandingMenuItem> items = [];
    for (final entry in grouped.entries) {
      final variants = entry.value;
      // Ordenar variantes según el orden fijo de tamaños
      variants.sort((a, b) {
        final indexA = _sizeOrder.indexOf(a.type);
        final indexB = _sizeOrder.indexOf(b.type);
        return (indexA == -1 ? 99 : indexA).compareTo(indexB == -1 ? 99 : indexB);
      });

      // Construir el mapa de sizeVariants
      final Map<String, String> sizeVariants = {};
      for (final v in variants) {
        sizeVariants[v.type] = "\$${v.price.toStringAsFixed(2)}";
      }

      // Usar la primera variante como referencia para datos comunes
      final first = variants.first;
      items.add(LandingMenuItem(
        name: first.name,
        category: first.category,
        price: "\$${first.price.toStringAsFixed(2)}", // Precio base (Personal)
        imageUrl: first.images.isNotEmpty ? first.images.first : '',
        plateColor: AppColors.goldDark,
        description: first.description ?? "Delicioso producto de la casa Fiumicello.",
        sizeVariants: sizeVariants,
      ));
    }
    return items;
  }

  /// Convierte un producto no-pizza a LandingMenuItem (sin variantes de tamaño)
  LandingMenuItem _productToMenuItem(Product p) {
    return LandingMenuItem(
      name: p.name,
      category: p.category,
      price: "\$${p.price.toStringAsFixed(2)}",
      imageUrl: p.images.isNotEmpty ? p.images.first : '',
      plateColor: AppColors.goldDark,
      description: p.description ?? "Delicioso producto de la casa Fiumicello.",
    );
  }

  List<LandingMenuItem> get _orderedItems {
    final productsProvider = context.watch<ProductsProvider>();

    if (productsProvider.products.isEmpty) {
      return [];
    }

    final allCats = productsProvider.products.map((p) => p.category).toSet();
    final sortedCats = _sortCategories(allCats);

    final List<LandingMenuItem> ordered = [];
    for (final cat in sortedCats) {
      final catProducts = productsProvider.products
          .where((p) => p.category == cat)
          .toList();

      if (cat == 'Pizzas') {
        // Agrupar las pizzas por nombre para mostrar variantes de tamaño
        ordered.addAll(_groupPizzaProducts(catProducts));
      } else {
        // Para las demás categorías, un producto = un card
        ordered.addAll(catProducts.map(_productToMenuItem));
      }
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              CategoryPills(
                categories: _displayCategories,
                selected: _selectedCategory,
                onSelect: (c) {
                  if (_selectedCategory != c) {
                    context.go('/$c');
                  }
                },
              ),
              Expanded(
                child: _showGrid
                    ? ProductGrid(
                        category: _selectedCategory,
                        items: _orderedItems,
                        onCategoryChange: (newCategory) {
                          if (_selectedCategory != newCategory) {
                            context.go('/$newCategory');
                          }
                        },
                      )
                    : ProductSwiper(
                        category: _selectedCategory,
                        items: _orderedItems,
                        onCategoryChange: (newCategory) {
                          if (_selectedCategory != newCategory) {
                            context.go('/$newCategory');
                          }
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: FloatingActionButton(
              heroTag: 'view_toggle_fab',
              backgroundColor: AppColors.primaryTextLight,
              foregroundColor: AppColors.goldDark,
              onPressed: () {
                setState(() {
                  _showGrid = !_showGrid;
                });
              },
              child: Icon(_showGrid ? Icons.layers : Icons.grid_view),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              heroTag: 'cart_fab',
              backgroundColor: AppColors.primaryTextLight,
              foregroundColor: AppColors.goldDark,
              onPressed: () {
                context.go('/cart');
              },
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
