class ContentOrders {
  static const String pageTitle = 'Pedidos Realizados';
  static const String subtitle = 'Historial de tus compras';

  static const String orderNumber = 'Pedido #';
  static const String dateLabel = 'Fecha: ';
  static const String totalLabel = 'Total: ';
  static const String itemsLabel = ' artículos';
  static const String itemLabel = ' artículo';

  static const String statusDelivered = 'Entregado';
  static const String statusProcessing = 'En Preparación';
  static const String statusCancelled = 'Cancelado';
  static const String statusOnTheWay = 'En Camino';

  static const String btnReorder = 'Volver a pedir';
  static const String btnDetails = 'Ver Detalles';

  // Strings for Order Details Page
  static const String detailsTitle = 'Detalles del Pedido';
  static const String productsSection = 'Productos';
  static const String paymentSummarySection = 'Resumen de Pago';
  static const String shippingAddressSection = 'Dirección de Envío';
  static const String subtotalLabel = 'Subtotal';
  static const String shippingCostLabel = 'Envío';
}

class MockOrderDetailItem {
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;

  MockOrderDetailItem({
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

class MockOrderData {
  final String id;
  final String date;
  final double subtotal;
  final double shippingCost;
  final double total;
  final int itemCount;
  final String status;
  final String shippingAddress;
  final List<MockOrderDetailItem> items;

  MockOrderData({
    required this.id,
    required this.date,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.itemCount,
    required this.status,
    required this.shippingAddress,
    required this.items,
  });
}

// Datos quemados simulando la base de datos de pedidos
final List<MockOrderData> mockOrders = [
  MockOrderData(
      id: 'ORD-98245',
      date: '15 Oct, 2024 - 14:30',
      subtotal: 115.50,
      shippingCost: 10.00,
      total: 125.50,
      itemCount: 3,
      status: ContentOrders.statusDelivered,
      shippingAddress: 'Av. Principal 123, Ciudad, País, 12345',
      items: [
        MockOrderDetailItem(
            productName: 'Camisa Casual',
            imageUrl: 'https://via.placeholder.com/80',
            price: 45.00,
            quantity: 1),
        MockOrderDetailItem(
            productName: 'Pantalón Chino',
            imageUrl: 'https://via.placeholder.com/80',
            price: 55.50,
            quantity: 1),
        MockOrderDetailItem(
            productName: 'Calcetines Base',
            imageUrl: 'https://via.placeholder.com/80',
            price: 15.00,
            quantity: 1),
      ]),
  MockOrderData(
      id: 'ORD-98250',
      date: '18 Oct, 2024 - 19:45',
      subtotal: 40.00,
      shippingCost: 5.00,
      total: 45.00,
      itemCount: 1,
      status: ContentOrders.statusProcessing,
      shippingAddress: 'Calle Secundaria 456, Ciudad, País, 67890',
      items: [
        MockOrderDetailItem(
            productName: 'Gorra Deportiva',
            imageUrl: 'https://via.placeholder.com/80',
            price: 40.00,
            quantity: 1),
      ]),
  MockOrderData(
      id: 'ORD-98102',
      date: '02 Sep, 2024 - 12:15',
      subtotal: 80.00,
      shippingCost: 9.90,
      total: 89.90,
      itemCount: 2,
      status: ContentOrders.statusCancelled,
      shippingAddress: 'Av. Principal 123, Ciudad, País, 12345',
      items: [
        MockOrderDetailItem(
            productName: 'Sudadera Básica',
            imageUrl: 'https://via.placeholder.com/80',
            price: 50.00,
            quantity: 1),
        MockOrderDetailItem(
            productName: 'Taza de Café',
            imageUrl: 'https://via.placeholder.com/80',
            price: 30.00,
            quantity: 1),
      ]),
  MockOrderData(
      id: 'ORD-98260',
      date: 'Hoy, 20:15',
      subtotal: 200.00,
      shippingCost: 10.00,
      total: 210.00,
      itemCount: 5,
      status: ContentOrders.statusOnTheWay,
      shippingAddress: 'Calle Nueva 789, Ciudad, País, 54321',
      items: [
        MockOrderDetailItem(
            productName: 'Zapatos de Cuero',
            imageUrl: 'https://via.placeholder.com/80',
            price: 120.00,
            quantity: 1),
        MockOrderDetailItem(
            productName: 'Cinturón Elegante',
            imageUrl: 'https://via.placeholder.com/80',
            price: 40.00,
            quantity: 1),
        MockOrderDetailItem(
            productName: 'Corbata Estampada',
            imageUrl: 'https://via.placeholder.com/80',
            price: 40.00,
            quantity: 3),
      ]),
];
