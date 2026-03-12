import 'package:responsive_app/models/landing_menu_item.dart';

class CartItemModel {
  final LandingMenuItem product;
  int quantity;
  final String? selectedSize;
  final String? specificPrice;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.specificPrice,
  });
}
