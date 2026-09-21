import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imageUrl,
    required super.isActive,
  });

  factory CategoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      imageUrl: category.imageUrl,
      isActive: category.isActive,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'imageUrl': imageUrl, 'isActive': isActive};
  }

  Category toEntity() {
    return Category(id: id, name: name, imageUrl: imageUrl, isActive: isActive);
  }
}
