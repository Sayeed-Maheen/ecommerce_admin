import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/features/products/domain/entities/product_variant.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/product_variant_model.dart';

abstract class ProductVariantRemoteDataSource {
  Future<List<ProductVariantModel>> getVariants(String productId);

  Future<ProductVariantModel> createVariant(ProductVariantModel variant);

  Future<ProductVariantModel> updateVariant(ProductVariantModel variant);

  Future<void> deleteVariant(String id);
}

class ProductVariantRemoteDataSourceImpl implements ProductVariantRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductVariantRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _variants =>
      firestore.collection('product_variants');

  @override
  Future<List<ProductVariantModel>> getVariants(String productId) async {
    try {
      final snapshot = await _variants
          .where('productId', isEqualTo: productId)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => ProductVariantModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to load product variants.');
    }
  }

  @override
  Future<ProductVariantModel> createVariant(ProductVariantModel variant) async {
    try {
      final doc = await _variants.add(variant.toFirestore());

      return ProductVariantModel.fromEntity(
        ProductVariant(
          id: doc.id,
          productId: variant.productId,
          name: variant.name,
          price: variant.price,
          stock: variant.stock,
          isActive: variant.isActive,
        ),
      );
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to create product variant.');
    }
  }

  @override
  Future<ProductVariantModel> updateVariant(ProductVariantModel variant) async {
    try {
      await _variants.doc(variant.id).update(variant.toFirestore());

      return variant;
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to update product variant.');
    }
  }

  @override
  Future<void> deleteVariant(String id) async {
    try {
      await _variants.doc(id).delete();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to delete product variant.');
    }
  }
}
