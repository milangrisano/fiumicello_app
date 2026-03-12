import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart'; // Solo para LandingStrings
import 'package:responsive_app/page/buy_cart_page/widget_cart/list_tile_product.dart';
import 'package:responsive_app/page/buy_cart_page/widget_cart/order_sumary.dart';
import 'package:responsive_app/page/buy_cart_page/widget_cart/payment_method.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/cart_provider.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedPaymentMethod = 0;
  bool _isHoveringBack = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isHoveringBack = true),
              onTapUp: (_) {
                setState(() => _isHoveringBack = false);
                context.go('/');
              },
              onTapCancel: () => setState(() => _isHoveringBack = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(
                    _isHoveringBack ? -5.0 : 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_ios,
                        size: 14, color: AppColors.goldDark),
                    const SizedBox(width: 4),
                    Text(
                      LandingStrings.btnBackToProducts,
                      style: AppTextStyles.w500(
                          fontSize: 14, color: AppColors.goldDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LandingStrings.cartTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w500,
              color: isDark
                  ? AppColors.goldDark
                  : Colors.black87, // O Theme.of(context).colorScheme.onSurface
            ),
          ),
          const SizedBox(height: 24),
          // Usamos Expanded para que ocupe todo el espacio disponible hacia abajo
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Scrollable (Lista de productos)
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: ListTileProduct(
                        items: cartProvider.items,
                        onIncrement: cartProvider.incrementQuantity,
                        onDecrement: cartProvider.decrementQuantity,
                        onRemove: cartProvider.removeItem,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Columna derecha: Fija (Resumen de orden y método de pago)
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    // Le ponemos scroll tbién a la derecha por si la pantalla es muy pequeña a lo alto,
                    // pero normalmente se verá fija sin necesidad de moverla.
                    child: Column(
                      children: [
                        OrderSummary(
                            subtotal: cartProvider.subtotal,
                            tax: cartProvider.tax,
                            delivery: cartProvider.delivery,
                            total: cartProvider.total),
                        if (authProvider.isAuthenticated) ...[
                          const SizedBox(height: 24),
                          PaymentMethod(
                            selectedValue: _selectedPaymentMethod,
                            onChanged: (val) =>
                                setState(() => _selectedPaymentMethod = val ?? 0),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
