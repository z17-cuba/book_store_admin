import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';

class GeneralBookDomain extends BookDomain {
  GeneralBookDomain({
    super.bookId,
    required super.title,
    required super.subtitle,
    required super.isbn,
    required super.description,
    required super.language,
    required super.status,
    super.publisher,
    required super.pageCount,
    required super.contentRating,
    super.rating,
    super.thumbnailUrl,
    super.createdAt,
    super.updatedAt,
    super.categories,
    super.tags,
    super.authors,
  });

  @override
  BookType get bookType => BookType.book;
}
