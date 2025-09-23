class CategoryDomain {
  CategoryDomain({
    required this.id,
    required this.name,
    required this.description,
    required this.parentCategoryId,
    required this.displayOrder,
  });

  final String id;
  final String? name;
  final String? description;
  final String? parentCategoryId;
  final int? displayOrder;
}
