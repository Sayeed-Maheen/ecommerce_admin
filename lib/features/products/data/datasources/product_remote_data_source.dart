import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> createProduct(ProductModel product);

  Future<ProductModel> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _products => firestore.collection('products');

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _products.orderBy('name').get();

      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.id, doc.data())).toList();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to load products.');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final docRef = await _products.add(product.toFirestore());

      return ProductModel(
        id: docRef.id,
        name: product.name,
        description: product.description,
        categoryId: product.categoryId,
        imageUrl: product.imageUrl,
        price: product.price,
        isActive: product.isActive,
      );
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to create product.');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      await _products.doc(product.id).update(product.toFirestore());

      return product;
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to update product.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _products.doc(id).delete();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to delete product.');
    }
  }
}
