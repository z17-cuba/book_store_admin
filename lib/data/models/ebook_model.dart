import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class EbookModel {
  EbookModel({
    required this.className,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.fileUrl,
    required this.fileFormat,
    required this.fileSizeMb,
    required this.book,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;
  final String? fileFormat;
  final double? fileSizeMb;
  final ParsePointer? book;

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      fileUrl: json["file"]['url'],
      fileFormat: json["fileFormat"],
      fileSizeMb: json["fileSizeMb"],
      book: json["book"] == null ? null : ParsePointer.fromJson(json["book"]),
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $fileUrl, $fileFormat, $fileSizeMb, $book, ";
  }
}
