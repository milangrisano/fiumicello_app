import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_addresses.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

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

          // Title & Subtitle
          Text(
            ContentAddresses.pageTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w600,
              color: isDark ? AppColors.goldLightDark : AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ContentAddresses.subtitle,
            style: AppTextStyles.text(
              fontSize: 16,
              weight: FontWeight.w400,
              color: isDark
                  ? (Colors.grey[400] ?? Colors.grey)
                  : AppColors.secondaryTextLight,
            ),
          ),
          const SizedBox(height: 32),

          // Addresses List
          Expanded(
            child: ListView.separated(
              itemCount: mockAddresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final address = mockAddresses[index];
                return _AddressCard(address: address, isDark: isDark);
              },
            ),
          ),

          // Add New Address Button
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Show Add Address Modal
              },
              icon: Icon(Icons.add_location_alt_outlined,
                  color: AppColors.backgroundLight),
              label: Text(
                ContentAddresses.addNewAddress,
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

class _AddressCard extends StatelessWidget {
  final MockAddressData address;
  final bool isDark;

  const _AddressCard({
    required this.address,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = address.isDefault
        ? (isDark ? AppColors.goldLightDark : AppColors.goldDark)
        : (isDark ? const Color(0xFF444444) : AppColors.borderLight);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: address.isDefault ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  address.icon,
                  color: isDark ? AppColors.goldLightDark : AppColors.goldDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address.label,
                          style: AppTextStyles.text(
                            fontSize: 18,
                            weight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.primaryTextLight,
                          ),
                        ),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.goldLightDark
                                  : AppColors.goldDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ContentAddresses.defaultIndicator,
                              style: AppTextStyles.text(
                                fontSize: 10,
                                weight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.goldLightDark
                                    : AppColors.goldDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      address.fullAddress,
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: isDark
                            ? (Colors.grey[400] ?? Colors.grey)
                            : AppColors.secondaryTextLight,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      '${address.city}, ${address.zipCode}',
                      style: AppTextStyles.text(
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: isDark
                            ? (Colors.grey[500] ?? Colors.grey)
                            : AppColors.mutedTextLight,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  ContentAddresses.editLink,
                  style: AppTextStyles.text(
                    fontSize: 14,
                    weight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),
              ),
              if (!address.isDefault) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    ContentAddresses.deleteLink,
                    style: AppTextStyles.text(
                      fontSize: 14,
                      weight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
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
