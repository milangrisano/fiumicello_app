import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_cards.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          _BackButton(),
          const SizedBox(height: 24),

          // Title
          Text(
            ContentCards.pageTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w600,
              color: isDark ? AppColors.goldLightDark : AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ContentCards.subtitle,
            style: AppTextStyles.text(
              fontSize: 16,
              weight: FontWeight.w400,
              color: isDark
                  ? (Colors.grey[400] ?? Colors.grey)
                  : AppColors.secondaryTextLight,
            ),
          ),
          const SizedBox(height: 32),

          // Card List
          Expanded(
            child: ListView.separated(
              itemCount: mockCards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final card = mockCards[index];
                return _CreditCardWidget(card: card, isDark: isDark);
              },
            ),
          ),

          // Add New Card Button
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Show Add Card Modal
              },
              icon: Icon(Icons.add_circle_outline,
                  color: AppColors.backgroundLight),
              label: Text(
                ContentCards.addNewCard,
                style: AppTextStyles.text(
                  fontSize: 16,
                  weight: FontWeight.w600,
                  color: AppColors.backgroundLight,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.goldLightDark : AppColors.goldDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditCardWidget extends StatelessWidget {
  final MockCardData card;
  final bool isDark;

  const _CreditCardWidget({
    required this.card,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Generate an elegant gradient based on the theme and if it is the default card
    final Gradient cardGradient = card.isDefault
        ? LinearGradient(
            colors: isDark
                ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)]
                : [const Color(0xFF1A1A1A), const Color(0xFF333333)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: isDark
                ? [const Color(0xFF444444), const Color(0xFF2A2A2A)]
                : [const Color(0xFF888888), const Color(0xFF555555)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final textColor =
        Colors.white; // Text on cards is usually white or very light
    final borderColor = card.isDefault
        ? (isDark ? AppColors.goldLightDark : AppColors.goldDark)
        : Colors.transparent;

    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Logo & Card Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.credit_card,
                color: textColor.withOpacity(0.8),
                size: 32,
              ),
              Text(
                card.cardType,
                style: AppTextStyles.text(
                  fontSize: 18,
                  weight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),

          // Middle: Card Number (Masked)
          Text(
            '**** **** **** ${card.lastFourDigits}',
            style: AppTextStyles.text(
              fontSize: 22,
              weight: FontWeight.w500,
              color: textColor,
            ),
          ),

          // Bottom Row: Holder Name & Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder'.toUpperCase(),
                    style: AppTextStyles.text(
                      fontSize: 10,
                      weight: FontWeight.w400,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.cardHolder.toUpperCase(),
                    style: AppTextStyles.text(
                      fontSize: 14,
                      weight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ContentCards.expiresLabel.toUpperCase(),
                    style: AppTextStyles.text(
                      fontSize: 10,
                      weight: FontWeight.w400,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.expiryDate,
                    style: AppTextStyles.text(
                      fontSize: 14,
                      weight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
