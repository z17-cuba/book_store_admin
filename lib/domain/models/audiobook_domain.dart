import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';

class AudiobookDomain extends BookDomain {
  AudiobookDomain({
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
    // Audiobook-specific fields
    required this.id,
    required this.audioFileUrl,
    required this.fileFormat,
    required this.totalDurationSeconds,
    required this.narratorName,
    required this.bitrate,
    required this.sampleRate,
  });

  final String? id;
  final String? audioFileUrl;
  final String? fileFormat;
  final int? totalDurationSeconds;
  final String? narratorName;
  final int? bitrate;
  final int? sampleRate;

  @override
  BookType get bookType => BookType.audiobook;

  // Convenience methods for audiobooks
  String get formattedDuration {
    if (totalDurationSeconds == null) return 'Unknown';
    final hours = totalDurationSeconds! ~/ 3600;
    final minutes = (totalDurationSeconds! % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  String get audioQuality {
    if (bitrate == null || sampleRate == null) return 'Unknown';
    return '$bitrate kbps, $sampleRate Hz';
  }
}
