import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/product.dart';

class ProductsService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
