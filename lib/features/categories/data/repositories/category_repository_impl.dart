import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<List<Category>> getCategories() async {
    final models = await dataSource.getCategories();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Category> createCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);

    final createdModel = await dataSource.createCategory(model);

    return createdModel.toEntity();
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);

    final updatedModel = await dataSource.updateCategory(model);

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteCategory(String id) async {
    await dataSource.deleteCategory(id);
  }
}
