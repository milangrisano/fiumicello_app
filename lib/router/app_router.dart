import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/page/buy_cart_page/cart_page.dart';
import 'package:responsive_app/responsive/reponsive_layout.dart';
import 'package:responsive_app/responsive/desktop_scaffold.dart';
import 'package:responsive_app/responsive/mobile_scaffold.dart';
import 'package:responsive_app/responsive/tablet_scaffold.dart';
import 'package:responsive_app/page/customer_info_page/customer_info_page.dart';
import 'package:responsive_app/page/cards_page/cards_page.dart';
import 'package:responsive_app/page/addresses_page/addresses_page.dart';
import 'package:responsive_app/page/orders_page/orders_page.dart';
import 'package:responsive_app/page/orders_page/order_details_page.dart';

import 'package:responsive_app/provider/auth_provider.dart';

// Definimos una clave global para el Navigator, para poder mostrar dialogos
// desde fuera de un widget específico (o usarla en redirecciones diferidas)
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  // Le decimos a GoRouter que recalcule las rutas cuando el AuthProvider notifique cambios (Login/Logout)
  refreshListenable: AuthProvider.instance,
  redirect: (context, state) {
    final isAuthenticated = AuthProvider.instance.isAuthenticated;

    // Rutas protegidas que requieren autenticación
    final isProtectedRoute = state.matchedLocation.startsWith('/customer-info') ||
        state.matchedLocation.startsWith('/cards') ||
        state.matchedLocation.startsWith('/addresses') ||
        state.matchedLocation.startsWith('/orders');

    // Si el usuario intenta ir a una ruta protegida y no está autenticado, lo redirige a /
    if (isProtectedRoute && !isAuthenticated) {
      return '/';
    }

    return null; // Deja que siga con la navegación normal
  },
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
      path: '/customer-info',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: CustomerInfoPage()),
        tabletScaffold: TabletScaffold(body: CustomerInfoPage()),
        desktopScaffold: DesktopScaffold(body: CustomerInfoPage()),
      ),
    ),
    GoRoute(
      path: '/cards',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: CardsPage()),
        tabletScaffold: TabletScaffold(body: CardsPage()),
        desktopScaffold: DesktopScaffold(body: CardsPage()),
      ),
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: AddressesPage()),
        tabletScaffold: TabletScaffold(body: AddressesPage()),
        desktopScaffold: DesktopScaffold(body: AddressesPage()),
      ),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const ResponsiveLayout(
        mobileScaffold: MobileScaffold(body: OrdersPage()),
        tabletScaffold: TabletScaffold(body: OrdersPage()),
        desktopScaffold: DesktopScaffold(body: OrdersPage()),
      ),
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (context, state) {
        final orderId = state.pathParameters['id'] ?? '';
        return ResponsiveLayout(
          mobileScaffold:
              MobileScaffold(body: OrderDetailsPage(orderId: orderId)),
          tabletScaffold:
              TabletScaffold(body: OrderDetailsPage(orderId: orderId)),
          desktopScaffold:
              DesktopScaffold(body: OrderDetailsPage(orderId: orderId)),
        );
      },
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
