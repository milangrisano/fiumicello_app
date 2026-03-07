import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsive_app/models/auth_response.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000';

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      throw Exception('Error de conexión o autenticación: $e');
    }
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Error al crear la cuenta');
      }
    } catch (e) {
      throw Exception('Error de conexión o registro: $e');
    }
  }
}
