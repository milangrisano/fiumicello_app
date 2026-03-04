import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_orders.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Find matching order in mock data
    final order = mockOrders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => mockOrders.first, // Fallback
    );

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              _BackButton(),
              const SizedBox(height: 24),

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ContentOrders.detailsTitle,
                    style: AppTextStyles.text(
                      fontSize: 28,
                      weight: FontWeight.w600,
                      color:
                          isDark ? AppColors.goldLightDark : AppColors.goldDark,
                    ),
                  ),
                  _OrderStatusBadge(status: order.status, isDark: isDark),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${ContentOrders.orderNumber}${order.id.split('-').last} • ${order.date}',
                style: AppTextStyles.text(
                  fontSize: 14,
                  weight: FontWeight.w400,
                  color: isDark
                      ? (Colors.grey[400] ?? Colors.grey)
                      : AppColors.secondaryTextLight,
                ),
              ),
              const SizedBox(height: 32),

              // Progress Tracker (Visual representation)
              _OrderProgressTracker(status: order.status, isDark: isDark),
              const SizedBox(height: 32),

              // Products Section
              Text(
                ContentOrders.productsSection,
                style: AppTextStyles.text(
                  fontSize: 18,
                  weight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryTextLight,
                ),
              ),
              const SizedBox(height: 16),
              ...order.items
                  .map((item) => _ProductItem(item: item, isDark: isDark))
                  .toList(),
              const SizedBox(height: 32),

              // Shipping Address Section
              Text(
                ContentOrders.shippingAddressSection,
                style: AppTextStyles.text(
                  fontSize: 18,
                  weight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryTextLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF444444)
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color:
                          isDark ? AppColors.goldLightDark : AppColors.goldDark,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        order.shippingAddress,
                        style: AppTextStyles.text(
                          fontSize: 14,
                          weight: FontWeight.w400,
                          color: isDark
                              ? Colors.grey[300]!
                              : AppColors.primaryTextLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Payment Summary Section
              Text(
                ContentOrders.paymentSummarySection,
                style: AppTextStyles.text(
                  fontSize: 18,
                  weight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryTextLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF444444)
                        : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: ContentOrders.subtotalLabel,
                      amount: order.subtotal,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: ContentOrders.shippingCostLabel,
                      amount: order.shippingCost,
                      isDark: isDark,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ContentOrders.totalLabel,
                          style: AppTextStyles.text(
                            fontSize: 16,
                            weight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryTextLight,
                          ),
                        ),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: AppTextStyles.text(
                            fontSize: 22,
                            weight: FontWeight.bold,
                            color: isDark
                                ? AppColors.goldLightDark
                                : AppColors.buttonGreenLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48), // Bottom Padding
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final MockOrderDetailItem item;
  final bool isDark;

  const _ProductItem({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppTextStyles.text(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cant: ${item.quantity}',
                  style: AppTextStyles.text(
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: isDark
                        ? Colors.grey[400]!
                        : AppColors.secondaryTextLight,
                  ),
                ),
              ],
            ),
          ),
          // Price
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: AppTextStyles.text(
              fontSize: 16,
              weight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.primaryTextLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDark;

  const _SummaryRow(
      {required this.label, required this.amount, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.text(
            fontSize: 14,
            weight: FontWeight.w400,
            color: isDark ? Colors.grey[400]! : AppColors.secondaryTextLight,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: AppTextStyles.text(
            fontSize: 14,
            weight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.primaryTextLight,
          ),
        ),
      ],
    );
  }
}

// Progress Bar specific logic matching statuses defined in content_orders.dart
class _OrderProgressTracker extends StatelessWidget {
  final String status;
  final bool isDark;

  const _OrderProgressTracker({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (status == ContentOrders.statusCancelled) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.red.withOpacity(0.1) : Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Este pedido fue cancelado',
              style: AppTextStyles.text(
                fontSize: 14,
                weight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    int currentStep = 0;
    if (status == ContentOrders.statusProcessing) currentStep = 1;
    if (status == ContentOrders.statusOnTheWay) currentStep = 2;
    if (status == ContentOrders.statusDelivered) currentStep = 3;

    final activeColor = isDark ? AppColors.goldLightDark : AppColors.goldDark;
    final inactiveColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Row(
      children: [
        _buildStepIndicator(
            'Procesando', currentStep >= 1, activeColor, inactiveColor, isDark),
        _buildLine(currentStep >= 2, activeColor, inactiveColor),
        _buildStepIndicator(
            'En Camino', currentStep >= 2, activeColor, inactiveColor, isDark),
        _buildLine(currentStep >= 3, activeColor, inactiveColor),
        _buildStepIndicator(
            'Entregado', currentStep >= 3, activeColor, inactiveColor, isDark),
      ],
    );
  }

  Widget _buildStepIndicator(String label, bool isActive, Color activeColor,
      Color inactiveColor, bool isDark) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : inactiveColor,
          ),
          child: isActive
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.text(
            fontSize: 10,
            weight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? (isDark ? Colors.white : AppColors.primaryTextLight)
                : (isDark ? Colors.grey[500]! : AppColors.secondaryTextLight),
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive, Color activeColor, Color inactiveColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20), // Align with circle center
        height: 2,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool isDark;

  const _OrderStatusBadge({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case ContentOrders.statusDelivered:
        bgColor = isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50;
        textColor = isDark ? Colors.greenAccent : Colors.green.shade700;
        break;
      case ContentOrders.statusProcessing:
      case ContentOrders.statusOnTheWay:
        bgColor =
            isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50;
        textColor = isDark ? Colors.orangeAccent : Colors.orange.shade800;
        break;
      case ContentOrders.statusCancelled:
        bgColor = isDark ? Colors.red.withOpacity(0.2) : Colors.red.shade50;
        textColor = isDark ? Colors.redAccent : Colors.red.shade700;
        break;
      default:
        bgColor = isDark ? Colors.grey.withOpacity(0.2) : Colors.grey.shade200;
        textColor = isDark ? Colors.white : Colors.black87;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.text(
          fontSize: 12,
          weight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _isHoveringBack = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHoveringBack = true),
        onTapUp: (_) {
          setState(() => _isHoveringBack = false);
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/orders');
          }
        },
        onTapCancel: () => setState(() => _isHoveringBack = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform:
              Matrix4.translationValues(_isHoveringBack ? -5.0 : 0.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios,
                  size: 14, color: AppColors.goldDark),
              const SizedBox(width: 4),
              Text(
                'Volver',
                style:
                    AppTextStyles.text(fontSize: 14, color: AppColors.goldDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
