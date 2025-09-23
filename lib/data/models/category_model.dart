class CategoryModel {
  CategoryModel({
    required this.name,
    required this.description,
    required this.parentCategoryId,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.objectId,
  });

  final String? name;
  final String? description;
  final dynamic parentCategoryId;
  final int? displayOrder;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? objectId;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json["name"],
      description: json["description"],
      parentCategoryId: json["parentCategoryId"],
      displayOrder: json["displayOrder"],
      isActive: json["isActive"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      objectId: json["objectId"],
    );
  }

  @override
  String toString() {
    return "$name, $description, $parentCategoryId, $displayOrder, $isActive, $createdAt, $updatedAt, $objectId, ";
  }
}
