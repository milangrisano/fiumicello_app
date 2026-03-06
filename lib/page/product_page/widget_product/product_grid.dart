import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/button_card.dart';
import 'package:responsive_app/models/landing_menu_item.dart';
import 'package:responsive_app/content/content_landing.dart'; // Solo para LandingStrings
import 'package:responsive_app/page/product_page/widget_product/contact_footer.dart';

// ─────────────────────────────────────────
// Product Grid
// ─────────────────────────────────────────
class ProductGrid extends StatefulWidget {
  final String category;
  final List<LandingMenuItem> items;
  final ValueChanged<String>? onCategoryChange;

  const ProductGrid({
    super.key,
    required this.category,
    required this.items,
    this.onCategoryChange,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late final ScrollController _scrollController;
  final Map<String, GlobalKey> _categoryKeys = {};
  bool _isScrollingProgrammatically = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Al inicializar usamos los items provistos para crear keys para las categorías disponibles
    final availableCategories = widget.items.map((item) => item.category).toSet();
    for (final cat in availableCategories) {
      _categoryKeys[cat] = GlobalKey();
    }

    // Scroll inicial a la categoría seleccionada después de que el primer frame se renderice
    if (widget.category.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _categoryKeys.containsKey(widget.category)) {
          _scrollToCategory(widget.category);
        }
      });
    }
  }

  void _onScroll() {
    if (_isScrollingProgrammatically || widget.onCategoryChange == null) return;

    String? visibleCategory;
    double minDistance = double.infinity;

    // The current offset of the scroll view
    final scrollOffset = _scrollController.offset;

    for (final entry in _categoryKeys.entries) {
      final key = entry.value;
      if (key.currentContext != null) {
        final renderObject = key.currentContext!.findRenderObject();
        if (renderObject is RenderBox) {
          // Obtener la posición Y global del elemento
          final position = renderObject.localToGlobal(Offset.zero).dy;

          // Calculamos la distancia desde el componente hasta la parte superior con un pequeño offset
          // para que el cambio suceda cuando el titulo este cerca del borde superior.
          final distance = (position - 150).abs();

          if (distance < minDistance) {
            minDistance = distance;
            visibleCategory = entry.key;
          }
        }
      }
    }

    // Scroll ha subido hasta arriba de todo (por encima del primer titulo)
    if (scrollOffset <= 0 && _categoryKeys.isNotEmpty) {
      widget.onCategoryChange!(_categoryKeys.keys.first);
      return;
    }

    if (visibleCategory != null && visibleCategory != widget.category) {
      widget.onCategoryChange!(visibleCategory);
    }
  }

  @override
  void didUpdateWidget(covariant ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si los items cambian, actualizar las llaves de categorías
    // pero NO borrar las existentes — solo agregar nuevas y quitar las obsoletas
    if (widget.items != oldWidget.items) {
      final newCategories = widget.items.map((item) => item.category).toSet();
      // Remover llaves de categorías que ya no existen
      _categoryKeys.removeWhere((key, _) => !newCategories.contains(key));
      // Agregar llaves para categorías nuevas
      for (final cat in newCategories) {
        _categoryKeys.putIfAbsent(cat, () => GlobalKey());
      }
    }

    if (widget.category != oldWidget.category) {
      // Deferimos el scroll hasta después de que el frame se renderice
      // para asegurar que las GlobalKeys estén asignadas al widget tree
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToCategory(widget.category);
        }
      });
    }
  }

  void _scrollToCategory(String categoryName) async {
    _isScrollingProgrammatically = true;

    if (_categoryKeys.isNotEmpty && categoryName == _categoryKeys.keys.first) {
      // Scroll to the absolute top for the first category
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
      _isScrollingProgrammatically = false;
      return;
    }

    final key = _categoryKeys[categoryName];
    if (key != null && key.currentContext != null) {
      final renderBox = key.currentContext!.findRenderObject() as RenderBox;

      // La posición 'localToGlobal(Offset.zero)' nos da relative position on screen
      final positionInViewport = renderBox.localToGlobal(Offset.zero).dy;

      // Aumentamos el offset superior para asegurar que el título quede bien visible
      // debajo de las "pills" de categoría y cualquier margin superior que tenga la pantalla.
      final topOffset = 180.0;

      final currentScrollOffset = _scrollController.offset;
      var targetOffset = currentScrollOffset + (positionInViewport - topOffset);

      // Clamp para no pasarnos de los limites del Scroll
      if (targetOffset < 0) {
        targetOffset = 0;
      } else if (targetOffset > _scrollController.position.maxScrollExtent) {
        targetOffset = _scrollController.position.maxScrollExtent;
      }

      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }

    // Pequeño delay adicional para asegurar que el scroll ha terminado de asentar
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted)
        setState(() {
          _isScrollingProgrammatically = false;
        });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Agrupar siempre todos los elementos por categoría respetando el orden original
    final Map<String, List<LandingMenuItem>> groupedItems = {};
    
    // Si tenemos items, creamos un set unico de sus correspondientes categorias
    final availableCategories = widget.items.map((item) => item.category).toSet().toList();
    
    // Y utilizamos el set dinamico en vez del estatico
    for (final catName in availableCategories) {
      final catItems = widget.items.where((item) => item.category == catName).toList();
      if (catItems.isNotEmpty) {
        groupedItems[catName] = catItems;
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.mutedTextLight),
        ),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 6.0,
        radius: const Radius.circular(10),
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildGroupedGrids(groupedItems),
          ),
        ),
      ),
    );
  }

  /// Construye un bloque individual de cuadrículas (la vista tradicional)
  List<Widget> _buildSingleGrid(String title, List<LandingMenuItem> gridItems) {
    return [
      Padding(
        key: _categoryKeys[title],
        padding: const EdgeInsets.only(bottom: 16),
        child: Builder(builder: (context) {
          return Text(
            title,
            style: AppTextStyles.text(
              fontSize: 24,
              weight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.74,
        ),
        itemCount: gridItems.length,
        itemBuilder: (_, i) => ProductCard(item: gridItems[i]),
      ),
    ];
  }

  /// Construye múltiples bloques de cuadrículas dependiendo de sus categorías
  List<Widget> _buildGroupedGrids(
      Map<String, List<LandingMenuItem>> groupedData) {
    final List<Widget> children = [];

    groupedData.forEach((catName, catItems) {
      // Por cada grupo agregar su título y grid pertinente
      children.addAll(_buildSingleGrid(catName, catItems));

      // Separación visual entre categorías distintas
      children.add(const SizedBox(height: 32));
    });

    children.add(const ContactFooter());

    return children;
  }
}

// ─────────────────────────────────────────
// Product Card
// ─────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final LandingMenuItem item;
  final int imageFlex;
  final int textFlex;

  const ProductCard({
    super.key,
    required this.item,
    this.imageFlex = 2,
    this.textFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.goldLightDark : AppColors.borderLight,
            width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Expanded(
            flex: imageFlex,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: item.plateColor.withValues(alpha: 0.18),
                          child: Center(
                            child: Image.asset(
                              'assets/images/fiumicello_hat.png',
                              width: 60.0 * imageFlex,
                              height: 60.0 * imageFlex,
                              fit: BoxFit.contain,
                              // Optional: apply color if the hat is just a silhouette, 
                              // filtering the color to match the design (uncomment if needed)
                              // color: item.plateColor.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: item.plateColor.withValues(alpha: 0.18),
                        child: Center(
                          child: Image.asset(
                            'assets/images/fiumicello_hat.png',
                            width: 60.0 * imageFlex,
                            height: 60.0 * imageFlex,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          // Textos
          Expanded(
            flex: textFlex,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre del producto
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text(
                      fontSize: 13,
                      weight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.primaryTextLight,
                    ),
                  ),
                  const Spacer(),
                  // Descripción
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text(
                      fontSize: 10,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.secondaryTextLight,
                    ),
                  ),
                  const Spacer(),
                  // Sección de precios: variantes de tamaño para pizzas, precio simple para el resto
                  if (item.sizeVariants.isNotEmpty)
                    _buildSizeVariants(context, isDark)
                  else ...[
                    Text(
                      item.price,
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.primaryTextLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ButtonCard(
                      text: LandingStrings.btnAddToCart,
                      onPressed: () {},
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de variantes de tamaño para pizzas
  /// Muestra 3 columnas lado a lado: tamaño arriba, precio abajo
  Widget _buildSizeVariants(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: item.sizeVariants.entries.map((entry) {
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.key,
                style: AppTextStyles.text(
                  fontSize: 10,
                  weight: FontWeight.w500,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.secondaryTextLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                entry.value,
                style: AppTextStyles.text(
                  fontSize: 12,
                  weight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.primaryTextLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
