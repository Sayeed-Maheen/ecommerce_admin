class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isActive;

  const Category({required this.id, required this.name, this.imageUrl, required this.isActive});
}
