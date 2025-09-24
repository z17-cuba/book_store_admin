import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/data/models/tag_model.dart';

class BookModel {
  BookModel({
    this.className,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.subtitle,
    required this.isbn,
    required this.description,
    required this.language,
    required this.status,
    this.publisher,
    required this.pageCount,
    required this.contentRating,
    required this.rating,
    required this.thumbnail,
    this.categories,
    this.authors,
    this.tags,
  });

  final String? className;
  final String? objectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? subtitle;
  final String? isbn;
  final String? description;
  final String? language;
  final String? status;
  final PublisherModel? publisher;
  final int? pageCount;
  final String? contentRating;
  final double? rating;
  final String? thumbnail;
  final List<TagModel>? tags;
  final List<CategoryModel>? categories;
  final List<AuthorModel>? authors;

  factory BookModel.fromJson({
    required Map<String, dynamic> json,
    required List<TagModel> tags,
    required List<CategoryModel> categories,
    required List<AuthorModel> authors,
  }) {
    return BookModel(
      className: json["className"],
      objectId: json["objectId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      title: json["title"],
      subtitle: json["subtitle"],
      isbn: json["isbn"],
      description: json["description"],
      language: json["language"],
      status: json["status"],
      publisher: json["publisher"] == null
          ? null
          : PublisherModel.fromJson(json["publisher"]),
      pageCount: json["pageCount"],
      contentRating: json["contentRating"],
      rating: json["rating"],
      thumbnail: json["thumbnail"] == null ? null : json["thumbnail"]["url"],
      categories: categories,
      tags: tags,
      authors: authors,
    );
  }

  @override
  String toString() {
    return "$className, $objectId, $createdAt, $updatedAt, $title, $subtitle, $isbn, $description, $language, $status, $publisher, $pageCount, $contentRating, $rating, $thumbnail, $categories, $tags, $authors ";
  }
}
