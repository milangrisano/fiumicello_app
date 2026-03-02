import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';

// Definimos una clave global para el Navigator, para poder mostrar dialogos
// desde fuera de un widget específico (o usarla en redirecciones diferidas)
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  // Le decimos a GoRouter que recalcule las rutas cuando el AuthProvider notifique cambios (Login/Logout)
  // refreshListenable: AuthProvider.instance, // Opcional, comentar si no se usa Provider en el router directamente de momento
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: CartPage()),
        tabletScaffold: TabletScaffold(body: CartPage()),
        desktopScaffold: DesktopScaffold(body: CartPage()),
      ),
    ),
    GoRoute(
      path: '/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'];
        return ResponsiveLayout(
          mobileScaffold: MobileScaffold(category: category),
          tabletScaffold: TabletScaffold(category: category),
          desktopScaffold: DesktopScaffold(category: category),
        );
      },
    ),
  ],
);
