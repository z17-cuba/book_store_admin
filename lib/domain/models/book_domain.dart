import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';

abstract class BookDomain {
  BookDomain({
    this.bookId,
    required this.title,
    required this.subtitle,
    required this.isbn,
    required this.description,
    required this.language,
    required this.status,
    required this.publisher,
    required this.publicationDate,
    required this.pageCount,
    required this.contentRating,
    required this.rating,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    required this.tags,
    required this.authors,
  });

  final String? bookId;
  final String? title;
  final String? subtitle;
  final String? isbn;
  final String? description;
  final String? language;
  final String? status;
  final String? publisher;
  final DateTime? publicationDate;
  final int? pageCount;
  final String? contentRating;
  final double? rating;
  final String? thumbnailUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CategoryDomain>? categories;
  final List<String>? tags;
  final List<AuthorDomain>? authors;

  // Abstract method to get book type
  BookType get bookType;
}
