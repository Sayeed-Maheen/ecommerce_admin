import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    required super.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'stock': stock, 'isActive': isActive};
  }

  Product toEntity() {
    return Product(id: id, name: name, price: price, stock: stock, isActive: isActive);
  }
}
