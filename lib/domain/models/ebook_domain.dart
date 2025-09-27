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
    required this.fileSizeMBytes,
  });

  final String? id;
  final String? ebookFileUrl;
  final String? fileFormat;
  final double? fileSizeMBytes;

  @override
  BookType get bookType => BookType.ebook;

  // Convenience methods for file size
  String get formattedFileSize {
    if (fileSizeMBytes == null) return 'Unknown';

    return '${(fileSizeMBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileExtension {
    return fileFormat?.toUpperCase() ?? 'Unknown';
  }

  String get fileName {
    return ebookFileUrl != null
        ? ebookFileUrl!
            .substring(ebookFileUrl!.lastIndexOf('/') + 1, ebookFileUrl!.length)
        : '';
  }
}
