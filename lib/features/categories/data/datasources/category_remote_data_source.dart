import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> createCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _categories => firestore.collection('categories');

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _categories.orderBy('name').get();

      return snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc.id, doc.data())).toList();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to load categories.');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final docRef = await _categories.add(category.toFirestore());

      return CategoryModel(
        id: docRef.id,
        name: category.name,
        imageUrl: category.imageUrl,
        isActive: category.isActive,
      );
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to create category.');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      await _categories.doc(category.id).update(category.toFirestore());

      return category;
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to update category.');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _categories.doc(id).delete();
    } on FirebaseException catch (e) {
      throw AppException(e.message ?? 'Unable to delete category.');
    }
  }
}
