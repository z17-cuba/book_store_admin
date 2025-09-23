import 'package:book_store_admin/data/models/parse_types/parse_pointer.dart';

class AudiobookModel {
  AudiobookModel({
    required this.className,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.fileUrl,
    required this.fileFormat,
    required this.totalDurationSeconds,
    required this.book,
    required this.narratorName,
    required this.bitrate,
    required this.sampleRate,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;
  final String? fileFormat;
  final int? totalDurationSeconds;
  final ParsePointer? book;
  final String? narratorName;
  final int? bitrate;
  final int? sampleRate;

  factory AudiobookModel.fromJson(Map<String, dynamic> json) {
    return AudiobookModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      fileUrl: json["file"]['url'],
      fileFormat: json["fileFormat"],
      totalDurationSeconds: json["totalDurationSeconds"],
      book: json["book"] == null ? null : ParsePointer.fromJson(json["book"]),
      narratorName: json["narratorName"],
      bitrate: json["bitrate"],
      sampleRate: json["sampleRate"],
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $fileUrl, $fileFormat, $totalDurationSeconds, $book, $narratorName, $bitrate, $sampleRate, ";
  }
}
