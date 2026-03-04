import 'package:flutter/material.dart';

class ContentAddresses {
  static const String pageTitle = 'Direcciones Registradas';
  static const String subtitle = 'Administra tus lugares de entrega';
  static const String addNewAddress = 'Añadir Nueva Dirección';

  static const String labelHome = 'Casa';
  static const String labelWork = 'Trabajo';
  static const String labelOther = 'Otro';

  static const String defaultIndicator = 'Dirección principal';
  static const String editLink = 'Editar';
  static const String deleteLink = 'Eliminar';
}

class MockAddressData {
  final String label;
  final String fullAddress;
  final String city;
  final String zipCode;
  final IconData icon;
  final bool isDefault;

  MockAddressData({
    required this.label,
    required this.fullAddress,
    required this.city,
    required this.zipCode,
    required this.icon,
    this.isDefault = false,
  });
}

// Datos quemados simulando la base de datos de direcciones
final List<MockAddressData> mockAddresses = [
  MockAddressData(
    label: ContentAddresses.labelHome,
    fullAddress: 'Av. Las Palmas 1234, Apto 5B',
    city: 'Ciudad Metropolitana',
    zipCode: 'CP 10101',
    icon: Icons.home_rounded,
    isDefault: true,
  ),
  MockAddressData(
    label: ContentAddresses.labelWork,
    fullAddress: 'Torre Empresarial, Piso 10, Oficina 1004',
    city: 'Distrito Financiero',
    zipCode: 'CP 20202',
    icon: Icons.work_rounded,
  ),
];
