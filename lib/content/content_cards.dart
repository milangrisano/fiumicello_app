class ContentCards {
  static const String pageTitle = 'Tarjetas Registradas';
  static const String subtitle = 'Administra tus métodos de pago';
  static const String addNewCard = 'Añadir Nueva Tarjeta';
  static const String defaultCardHolder = 'Nombre Completo';
  static const String expiresLabel = 'Vence';
  static const String defaultExpiry = '12/28';

  // Nombres de algunos bancos/tipos de tarjeta simulados
  static const String visa = 'VISA';
  static const String mastercard = 'MasterCard';

  static const String cardEndingIn = 'Terminada en ';
}

class MockCardData {
  final String cardHolder;
  final String lastFourDigits;
  final String expiryDate;
  final String cardType;
  final bool isDefault;

  MockCardData({
    required this.cardHolder,
    required this.lastFourDigits,
    required this.expiryDate,
    required this.cardType,
    this.isDefault = false,
  });
}

// Datos quemados simulando la base de datos
final List<MockCardData> mockCards = [
  MockCardData(
    cardHolder: 'Juan Pérez',
    lastFourDigits: '4242',
    expiryDate: '10/25',
    cardType: ContentCards.visa,
    isDefault: true,
  ),
  MockCardData(
    cardHolder: 'Juan Pérez',
    lastFourDigits: '8811',
    expiryDate: '01/27',
    cardType: ContentCards.mastercard,
  ),
];
