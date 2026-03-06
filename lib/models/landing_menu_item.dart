import 'package:flutter/material.dart';

/// Modelo de datos para representar un producto en la Landing Page.
/// Se puebla exclusivamente con datos del backend (GET /products).
class LandingMenuItem {
  final String name;
  final String description;
  final String price;
  final String category;
  final Color plateColor;
  final String imageUrl;
  /// Mapa de tamaños y precios para pizzas: {'Personal': '\$20.90', 'Mediana': '\$44.90', 'Grande': '\$63.90'}
  /// Vacío para productos que no son pizzas.
  final Map<String, String> sizeVariants;

  const LandingMenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.plateColor,
    required this.imageUrl,
    this.sizeVariants = const {},
  });
}
