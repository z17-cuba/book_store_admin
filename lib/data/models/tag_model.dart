import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class TagModel {
  TagModel({
    required this.className,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.library,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final ParsePointer? library;

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      name: json["name"],
      library: json["library"] == null
          ? null
          : ParsePointer.fromJson(json["library"]),
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $name, $library, ";
  }
}
