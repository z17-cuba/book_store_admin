import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';

class EbookDomain extends BookDomain {
  EbookDomain({
    required super.bookId,
    required super.title,
    required super.subtitle,
    required super.isbn,
    required super.description,
    required super.language,
    required super.status,
    required super.publisher,
    required super.publicationDate,
    required super.pageCount,
    required super.contentRating,
    required super.rating,
    required super.thumbnailUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.categories,
    required super.tags,
    required super.authors,
    // Ebook-specific fields
    required this.id,
    required this.ebookFileUrl,
    required this.fileFormat,
    required this.fileSizeBytes,
  });

  final String? id;
  final String? ebookFileUrl;
  final String? fileFormat;
  final double? fileSizeBytes;

  @override
  BookType get bookType => BookType.ebook;

  // Convenience methods for ebooks
  String get formattedFileSize {
    if (fileSizeBytes == null) return 'Unknown';
    if (fileSizeBytes! < 1024 * 1024) {
      return '${(fileSizeBytes! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSizeBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get fileExtension {
    return fileFormat?.toUpperCase() ?? 'Unknown';
  }
}
