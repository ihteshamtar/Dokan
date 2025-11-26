class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final List<String> images;
  final String category;
  final int stock;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.images,
    required this.category,
    required this.stock,
    required this.isFeatured,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String categoryId;
    if (json['category'] is String) {
      categoryId = json['category'];
    } else if (json['category'] is Map<String, dynamic>) {
      categoryId = (json['category'] as Map<String, dynamic>)['_id'] ?? '';
    } else {
      categoryId = '';
    }

    List<String> images = [];
    if (json['images'] is List) {
      images = (json['images'] as List).map((e) => e as String).toList();
    } else if (json['image'] is String) {
      // Handle the case where the API sends a single 'image' string
      images = [json['image']];
    }

    // This is the fix: Check for both '_id' and 'id' from the API.
    final id = json['_id'] ?? json['id'] ?? '';

    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble() ?? 0.0,
      images: images,
      category: categoryId,
      stock: json['stock'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }
}
