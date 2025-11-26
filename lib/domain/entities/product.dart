class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final List<String> images;
  final String category;
  final int stock;
  final bool isFeatured;

  Product({
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
}
