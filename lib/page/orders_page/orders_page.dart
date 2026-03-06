import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_orders.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort orders specifically for display if needed (e.g. newest first)
    final sortedOrders = List<MockOrderData>.from(mockOrders)
      ..sort((a, b) => b.id.compareTo(a.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          _BackButton(),
          const SizedBox(height: 24),

          // Title & Subtitle
          Text(
            ContentOrders.pageTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w600,
              color: isDark ? AppColors.goldLightDark : AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ContentOrders.subtitle,
            style: AppTextStyles.text(
              fontSize: 16,
              weight: FontWeight.w400,
              color: isDark
                  ? (Colors.grey[400] ?? Colors.grey)
                  : AppColors.secondaryTextLight,
            ),
          ),
          const SizedBox(height: 32),

          // Orders List
          Expanded(
            child: ListView.separated(
              itemCount: sortedOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                return _OrderCard(order: order, isDark: isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final MockOrderData order;
  final bool isDark;

  const _OrderCard({
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor =
        isDark ? const Color(0xFF444444) : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.statusSuccessBgLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Top section specifying order number and status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ContentOrders.orderNumber}${order.id.split('-').last}',
                  style: AppTextStyles.text(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),
                _OrderStatusBadge(status: order.status, isDark: isDark),
              ],
            ),
          ),

          // Middle section with details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${ContentOrders.dateLabel}${order.date}',
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: isDark
                            ? (Colors.grey[400] ?? Colors.grey)
                            : AppColors.secondaryTextLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: isDark
                              ? AppColors.goldLightDark
                              : AppColors.goldDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${order.itemCount}${order.itemCount == 1 ? ContentOrders.itemLabel : ContentOrders.itemsLabel}',
                          style: AppTextStyles.text(
                            fontSize: 14,
                            weight: FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryTextLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ContentOrders.totalLabel,
                      style: AppTextStyles.text(
                        fontSize: 12,
                        weight: FontWeight.w400,
                        color: isDark
                            ? (Colors.grey[400] ?? Colors.grey)
                            : AppColors.secondaryTextLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: AppTextStyles.text(
                        fontSize: 20,
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

          // Bottom Actions
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/orders/${order.id}');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? AppColors.goldLightDark
                            : AppColors.goldDark,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      ContentOrders.btnDetails,
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w500,
                        color: isDark
                            ? AppColors.goldLightDark
                            : AppColors.goldDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.goldLightDark : AppColors.goldDark,
                      foregroundColor: AppColors.backgroundLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      ContentOrders.btnReorder,
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w600,
                        color: AppColors.backgroundLight,
                      ),
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
        bgColor = isDark
            ? AppColors.statusSuccessBgDark
            : AppColors.statusSuccessBgLight;
        textColor = isDark
            ? AppColors.statusSuccessTextDark
            : AppColors.statusSuccessTextLight;
        break;
      case ContentOrders.statusProcessing:
      case ContentOrders.statusOnTheWay:
        bgColor = isDark
            ? AppColors.statusPendingBgDark
            : AppColors.statusPendingBgLight;
        textColor = isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
        break;
      case ContentOrders.statusCancelled:
        bgColor = isDark
            ? AppColors.statusErrorBgDark
            : AppColors.statusErrorBgLight;
        textColor = isDark
            ? AppColors.statusErrorTextDark
            : AppColors.statusErrorTextLight;
        break;
      default:
        bgColor = isDark
            ? AppColors.statusDefaultBgDark
            : AppColors.statusDefaultBgLight;
        textColor = isDark
            ? AppColors.statusDefaultTextDark
            : AppColors.statusDefaultTextLight;
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
            context.go('/');
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
