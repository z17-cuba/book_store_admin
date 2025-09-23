import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class ReadingProgressModel {
  ReadingProgressModel({
    this.objectId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.book,
    this.contentType,
    this.contentId,
    this.progressPercentage,
    this.cfi,
    this.currentPositionSeconds,
    this.lastReadAt,
    this.readingTimeSeconds,
    this.isCompleted,
    this.completionDate,
  });

  String? objectId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ParsePointer? user;
  ParsePointer? book;
  String? contentType;
  String? contentId;
  double? progressPercentage;
  String? cfi;
  int? currentPositionSeconds;
  DateTime? lastReadAt;
  int? readingTimeSeconds;
  bool? isCompleted;
  DateTime? completionDate;

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      contentType: json["contentType"],
      contentId: json["contentId"],
      progressPercentage:
          double.tryParse(json["progressPercentage"].toString()) ?? 0,
      cfi: json["cfi"],
      currentPositionSeconds: json["currentPositionSeconds"],
      readingTimeSeconds: json["readingTimeSeconds"],
      isCompleted: json["isCompleted"],
      lastReadAt: DateTime.tryParse(json["lastReadAt"]['iso'] ?? ""),
      completionDate: json["completionDate"] != null
          ? DateTime.tryParse(json["completionDate"])
          : null,
      user: json["user"] == null ? null : ParsePointer.fromJson(json["user"]),
      book: json["book"] == null ? null : ParsePointer.fromJson(json["book"]),
    );
  }
}
