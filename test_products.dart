import 'package:responsive_app/services/products_service.dart';

void main() async {
  print("Testing ProductsService...");
  final service = ProductsService();
  try {
    final products = await service.getProducts();
    print("Success: Loaded ${products.length} products.");
    if (products.isNotEmpty) {
      print("First product: ${products.first.name} (Category: ${products.first.category})");
    }
  } catch (e) {
    print("Error: $e");
  }
}
