import 'package:responsive_app/models/landing_menu_item.dart';

class CartItemModel {
  final LandingMenuItem product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
}
