import 'package:flutter/material.dart';
import 'package:responsive_app/models/product.dart';
import 'package:responsive_app/services/products_service.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsService _service = ProductsService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductsProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    print("ProductsProvider: fetchProducts started");
    _isLoading = true;
    _error = null;
    
    // Defer the notification so it doesn't trigger state builds incorrectly 
    // when created directly inside the build method
    Future.microtask(() => notifyListeners());

    try {
      _products = await _service.getProducts();
      print("ProductsProvider: Loaded \${_products.length} products successfully");
    } catch (e) {
      print("ProductsProvider: Error loading products -> \$e");
      _error = e.toString();
    } finally {
      print("ProductsProvider: fetchProducts finished");
      _isLoading = false;
      notifyListeners();
    }
  }
}
