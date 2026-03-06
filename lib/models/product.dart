class Product {
  final String id;
  final String name;
  final String type;
  final String category;
  final String? description;
  final double price;
  final bool availability;
  final List<String> images;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    this.description,
    required this.price,
    this.availability = true,
    this.images = const [],
    this.isActive = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesList = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = (json['images'] as List)
            .map((item) => item['url'].toString())
            .toList();
      }
    }

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      availability: json['availability'] ?? true,
      images: List<String>.from(imagesList),
      isActive: json['isActive'] ?? true,
    );
  }
}
