import '../../domain/entities/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.price,
    required super.stock,
    required super.isActive,
  });

  factory ProductVariantModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductVariantModel(
      id: id,
      productId: data['productId'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      stock: (data['stock'] as num).toInt(),
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  factory ProductVariantModel.fromEntity(ProductVariant variant) {
    return ProductVariantModel(
      id: variant.id,
      productId: variant.productId,
      name: variant.name,
      price: variant.price,
      stock: variant.stock,
      isActive: variant.isActive,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'isActive': isActive,
    };
  }

  ProductVariant toEntity() {
    return ProductVariant(
      id: id,
      productId: productId,
      name: name,
      price: price,
      stock: stock,
      isActive: isActive,
    );
  }
}
