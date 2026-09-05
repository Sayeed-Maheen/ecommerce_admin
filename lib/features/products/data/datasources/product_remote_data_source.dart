import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));

    final data = [
      {'id': 'p001', 'name': 'iPhone 17', 'price': 999, 'stock': 10, 'isActive': true},
      {'id': 'p002', 'name': 'MacBook Air', 'price': 1299, 'stock': 5, 'isActive': true},
      {'id': 'p003', 'name': 'Old Product', 'price': 100, 'stock': 0, 'isActive': false},
    ];

    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
