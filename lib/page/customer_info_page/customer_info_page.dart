import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_customer_info.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class CustomerInfoPage extends StatelessWidget {
  const CustomerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.userName ?? 'Usuario Registrado';
    final userPhoto = authProvider.userPhoto;

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
            ContentCustomerInfo.pageTitle,
            style: AppTextStyles.text(
              fontSize: 32,
              weight: FontWeight.w600,
              color: isDark ? AppColors.goldLightDark : AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 32),

          // Profile Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.goldLightDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.goldDark,
                  backgroundImage:
                      userPhoto != null ? NetworkImage(userPhoto) : null,
                  child: userPhoto == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: AppTextStyles.text(
                          fontSize: 24,
                          weight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.primaryTextLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ContentCustomerInfo.editProfile,
                        style: AppTextStyles.text(
                          fontSize: 14,
                          weight: FontWeight.w500,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Info Items
          _InfoTile(
            icon: Icons.email_outlined,
            label: ContentCustomerInfo.emailLabel,
            value: ContentCustomerInfo.defaultEmail,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.phone_outlined,
            label: ContentCustomerInfo.phoneLabel,
            value: ContentCustomerInfo.defaultPhone,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.location_on_outlined,
            label: ContentCustomerInfo.addressLabel,
            value: ContentCustomerInfo.defaultAddress,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.calendar_today_outlined,
            label: ContentCustomerInfo.joinedDateLabel,
            value: ContentCustomerInfo.defaultJoinedDate,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.goldLightDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.goldDark,
            size: 28,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.text(
                  fontSize: 12,
                  weight: FontWeight.w400,
                  color: isDark
                      ? (Colors.grey[400] ?? Colors.grey)
                      : (Colors.grey[600] ?? Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.text(
                  fontSize: 16,
                  weight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.primaryTextLight,
                ),
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
