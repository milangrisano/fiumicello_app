import 'package:responsive_app/services/products_service.dart';
import 'dart:developer';

void main() async {
  log("Testing ProductsService...");
  final service = ProductsService();
  try {
    final products = await service.getProducts();
    log("Success: Loaded ${products.length} products.");
    if (products.isNotEmpty) {
      log("First product: ${products.first.name} (Category: ${products.first.category})");
    }
  } catch (e) {
    log("Error: $e");
  }
}
