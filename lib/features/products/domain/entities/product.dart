class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String? imageUrl;
  final double price;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    this.imageUrl,
    required this.price,
    required this.isActive,
  });
}
