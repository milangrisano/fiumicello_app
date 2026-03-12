import 'package:flutter/foundation.dart';
import 'package:responsive_app/models/cart_item_model.dart';
import 'package:responsive_app/models/landing_menu_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(LandingMenuItem product, {String? selectedSize, String? specificPrice}) {
    // Check if the exact same product and size is already in the cart
    final existingIndex = _items.indexWhere(
      (item) => item.product.name == product.name && item.selectedSize == selectedSize,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          selectedSize: selectedSize,
          specificPrice: specificPrice,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal {
    return _items.fold(0, (sum, item) {
      final priceStr = item.specificPrice ?? item.product.price;
      // Remove any '$' or '.' from the string before parsing, assuming COP format like "20.900" -> 20900
      final cleanStr = priceStr.replaceAll('\$', '').replaceAll('.', ''); 
      final price = double.tryParse(cleanStr) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  double get tax => subtotal * 0.095; // 9.5% tax calculation
  double get delivery => _items.isEmpty ? 0 : 5000.0; // Assume 5000 COP for delivery

  double get total => _items.isEmpty ? 0 : subtotal + tax + delivery;
}
