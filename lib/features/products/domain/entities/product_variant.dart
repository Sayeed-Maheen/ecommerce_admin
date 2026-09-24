class ProductVariant {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int stock;
  final bool isActive;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
    required this.isActive,
  });
}
