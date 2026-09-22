import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categoryId,
    super.imageUrl,
    required super.price,
    required super.isActive,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl,
      price: product.price,
      isActive: product.isActive,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'price': price,
      'isActive': isActive,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      imageUrl: imageUrl,
      price: price,
      isActive: isActive,
    );
  }
}
