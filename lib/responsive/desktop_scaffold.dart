import 'package:flutter/material.dart';
import 'package:responsive_app/page/product_page/landing_page.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/shared/login_modal.dart';
import 'package:responsive_app/shared/user_profile_drawer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/theme_provider.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class DesktopScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const DesktopScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _DesktopAppBar(),
      endDrawer: const UserProfileDrawer(),
      body: body ?? LandingPage(category: category),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}

class _DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DesktopAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(110);

  void _openLoginModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => LoginModal(
        onSuccess: () {
          // 1. Cierra el modal
          Navigator.of(context).pop();

          // 2. Inicia sesión en el manager local
          final auth = context.read<AuthProvider>();
          auth.login("simulated_jwt_token_from_header");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      toolbarHeight: 110,
      titleSpacing: 24,
      automaticallyImplyLeading: false,
      actions: [Container()],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                  context.watch<ThemeProvider>().isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22),
            ),
          ),
          Expanded(
            child: Image.asset(
              isDark ? 'assets/images/logo_gold.png' : 'assets/images/logo.png',
              height: 90,
            ),
          ),
          const SizedBox(width: 8),
          isAuthenticated
              ? Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.person,
                        color: AppColors.goldDark, size: 28),
                  );
                })
              : TextButton(
                  onPressed: () {
                    _openLoginModal(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.goldDark),
                    ),
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: AppTextStyles.w500(
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
