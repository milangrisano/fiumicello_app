import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_colors.dart';

import 'package:responsive_app/page/product_page/widget_product/product_grid.dart';
import 'package:responsive_app/page/product_page/widget_product/category_pills.dart';
import 'package:responsive_app/page/product_page/widget_product/product_swiper.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_app/models/landing_menu_item.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/products_provider.dart';
import 'package:responsive_app/provider/cart_provider.dart';
import 'package:responsive_app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:responsive_app/shared/fiumicello_loading_indicator.dart';
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
      final numberFormat = NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

      for (final v in variants) {
        sizeVariants[v.type] = numberFormat.format(v.price).trim();
      }

      // Usar la primera variante como referencia para datos comunes
      final first = variants.first;
      items.add(LandingMenuItem(
        name: first.name,
        category: first.category,
        price: numberFormat.format(first.price), // Precio base (Personal)
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
    final numberFormat = NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

    return LandingMenuItem(
      name: p.name,
      category: p.category,
      price: numberFormat.format(p.price).trim(),
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
    final productsProvider = context.watch<ProductsProvider>();

    if (productsProvider.isLoading) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: FiumicelloLoadingIndicator(size: 100.0),
        ),
      );
    }

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
            child: _AnimatedCartFab(
              onPressed: () => context.go('/cart'),
              itemCount: context.watch<CartProvider>().totalItems,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Animated Cart FAB
// ─────────────────────────────────────────
class _AnimatedCartFab extends StatefulWidget {
  final VoidCallback onPressed;
  final int itemCount;

  const _AnimatedCartFab({
    super.key,
    required this.onPressed,
    required this.itemCount,
  });

  @override
  State<_AnimatedCartFab> createState() => _AnimatedCartFabState();
}

class _AnimatedCartFabState extends State<_AnimatedCartFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Aumentamos ligeramente la duración para que se note más el efecto
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Hacemos la secuencia más exagerada y con un rebote (bounceOut) al final
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60.0,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _AnimatedCartFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Disparar animación si la cantidad de items aumenta
    if (widget.itemCount > oldWidget.itemCount) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FloatingActionButton(
            heroTag: 'cart_fab',
            backgroundColor: AppColors.primaryTextLight,
            foregroundColor: AppColors.goldDark,
            onPressed: widget.onPressed,
            child: Badge(
              isLabelVisible: widget.itemCount > 0,
              label: Text(
                '${widget.itemCount}',
                style: const TextStyle(color: AppColors.goldDark, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.buttonGreenLight,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        );
      },
    );
  }
}
