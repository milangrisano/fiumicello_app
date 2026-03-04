import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class UserProfileDrawer extends StatelessWidget {
  const UserProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.userName;
    final userPhoto = authProvider.userPhoto;

    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Column(
        children: [
          // Header del Drawer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.goldLightDark : AppColors.borderLight,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.goldDark,
                  backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
                  child: userPhoto == null 
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userName ?? 'Mi Perfil',
                  style: AppTextStyles.text(
                    fontSize: 22,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryTextLight,
                  ),
                ),
              ],
            ),
          ),
          
          // Opciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Información del cliente',
                  onTap: () {
                    // Navigate to user info
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.credit_card_outlined,
                  title: 'Tarjetas de crédito registradas',
                  onTap: () {
                    // Navigate to cards
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'Direcciones registradas',
                  onTap: () {
                    // Navigate to addresses
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.receipt_long_outlined,
                  title: 'Pedidos realizados',
                  onTap: () {
                    // Navigate to orders
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Divider(color: Colors.grey, thickness: 0.5),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.logout,
                  title: 'Cerrar sesión',
                  titleColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.read<AuthProvider>().logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : AppColors.primaryTextLight;
    final finalIconColor = iconColor ?? (isDark ? AppColors.goldDark : AppColors.buttonGreenLight);

    return ListTile(
      leading: Icon(icon, color: finalIconColor, size: 24),
      title: Text(
        title,
        style: AppTextStyles.text(
          color: titleColor ?? defaultColor,
          fontSize: 15,
          weight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: onTap,
    );
  }
}
