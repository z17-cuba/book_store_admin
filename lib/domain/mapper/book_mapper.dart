import 'package:book_store_admin/data/models/audiobook_model.dart';
import 'package:book_store_admin/data/models/book_model.dart';
import 'package:book_store_admin/data/models/ebook_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/domain/mapper/author_mapper.dart';
import 'package:book_store_admin/domain/mapper/categories_mapper.dart';
import 'package:book_store_admin/domain/models/audiobook_domain.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/models/ebook_domain.dart';
import 'package:book_store_admin/domain/models/general_book_domain.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class BookMapper {
  // Map AudiobookModel with BookModel to AudiobookDomain
  static AudiobookDomain audiobookToDomain(
    AudiobookModel audiobook,
    BookModel book,
  ) {
    return AudiobookDomain(
      bookId: book.objectId ?? '',
      title: book.title,
      subtitle: book.subtitle,
      isbn: book.isbn,
      description: book.description,
      language: book.language,
      status: book.status,
      publisher: book.publisher?.name ?? '',
      publicationDate: book.publicationDate,
      pageCount: book.pageCount?.toInt(),
      contentRating: book.contentRating,
      rating: book.rating,
      thumbnailUrl: book.thumbnail,
      createdAt: audiobook.createdAt,
      updatedAt: audiobook.updatedAt,
      categories: book.categories
          ?.map((c) => CategoriesMapper.categoryToDomain(c))
          .toList(),
      tags: book.tags?.map((t) => t['name'] as String).toList(),
      authors:
          book.authors?.map((a) => AuthorMapper.authorToDomain(a)).toList(),
      // Audiobook-specific fields
      id: audiobook.objectId ?? '',
      audioFileUrl: audiobook.fileUrl,
      fileFormat: audiobook.fileFormat,
      totalDurationSeconds: audiobook.totalDurationSeconds?.toInt(),
      narratorName: audiobook.narratorName,
      bitrate: audiobook.bitrate?.toInt(),
      sampleRate: audiobook.sampleRate,
    );
  }

  // Map EbookModel with BookModel to EbookDomain
  static EbookDomain ebookToDomain(
    EbookModel ebook,
    BookModel book,
  ) {
    return EbookDomain(
      bookId: book.objectId ?? '',
      title: book.title,
      subtitle: book.subtitle,
      isbn: book.isbn,
      description: book.description,
      language: book.language,
      status: book.status,
      publisher: book.publisher?.name ?? '',
      publicationDate: book.publicationDate,
      pageCount: book.pageCount?.toInt(),
      contentRating: book.contentRating,
      rating: book.rating,
      thumbnailUrl: book.thumbnail,
      createdAt: ebook.createdAt,
      updatedAt: ebook.updatedAt,
      categories: book.categories
          ?.map((c) => CategoriesMapper.categoryToDomain(c))
          .toList(),
      tags: book.tags?.map((t) => t['name'] as String).toList(),
      authors:
          book.authors?.map((a) => AuthorMapper.authorToDomain(a)).toList(),
      // Ebook-specific fields
      id: ebook.objectId ?? '',
      ebookFileUrl: ebook.fileUrl,
      fileFormat: ebook.fileFormat,
      fileSizeBytes: ebook.fileSizeMb,
    );
  }

  // Map BookModel to RegularBookDomain
  static GeneralBookDomain bookToDomain(
    BookModel book,
  ) {
    return GeneralBookDomain(
      bookId: book.objectId ?? '',
      title: book.title,
      subtitle: book.subtitle,
      isbn: book.isbn,
      description: book.description,
      language: book.language,
      status: book.status,
      publisher: book.publisher?.name ?? '',
      publicationDate: book.publicationDate,
      pageCount: book.pageCount?.toInt(),
      contentRating: book.contentRating,
      rating: book.rating,
      thumbnailUrl: book.thumbnail,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      categories: book.categories
          ?.map((c) => CategoriesMapper.categoryToDomain(c))
          .toList(),
      tags: book.tags?.map((t) => t['name'] as String).toList(),
      authors:
          book.authors?.map((a) => AuthorMapper.authorToDomain(a)).toList(),
    );
  }

  // Helper method to extract BookModel from ParseObject's included data
  static BookModel? _extractBookFromIncludes({
    required ParseBookModel parseBookModel,
    String? bookPointerKey,
  }) {
    try {
      final bookData = bookPointerKey != null
          ? parseBookModel.book.get<ParseObject>(bookPointerKey)
          : null;

      final json = (bookData ?? parseBookModel.book).toJson();

      return BookModel.fromJson(
        json: json,
        categories: parseBookModel.categories ?? [],
        tags: parseBookModel.tags ?? [],
        authors: parseBookModel.authors ?? [],
      );
    } catch (e) {
      return null;
    }
  }

  // Map ParseObject to EbookDomain (with included book data)
  static GeneralBookDomain? parseBookObjectToGeneralBookDomain(
    ParseBookModel parseBookObject,
  ) {
    try {
      final BookModel? book = _extractBookFromIncludes(
        parseBookModel: parseBookObject,
        bookPointerKey: 'book',
      );

      if (book != null) {
        return bookToDomain(book);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Map ParseObject to EbookDomain (with included book data)
  static EbookDomain? parseEbookObjectToEbookDomain(
    ParseBookModel parseEbookObject,
  ) {
    try {
      final EbookModel ebook = EbookModel.fromJson(
        parseEbookObject.book.toJson(),
      );
      final BookModel? book = _extractBookFromIncludes(
        parseBookModel: parseEbookObject,
        bookPointerKey: 'book',
      );

      if (book != null) {
        return ebookToDomain(
          ebook,
          book,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Map ParseObject to AudiobookDomain (with included book data)
  static AudiobookDomain? parseAudiobookObjectToAudiobookDomain(
    ParseBookModel parseEbookObject,
  ) {
    try {
      final AudiobookModel audiobook = AudiobookModel.fromJson(
        parseEbookObject.book.toJson(),
      );
      final BookModel? book = _extractBookFromIncludes(
        parseBookModel: parseEbookObject,
        bookPointerKey: 'book',
      );

      if (book != null) {
        return audiobookToDomain(
          audiobook,
          book,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Map BookDomain to BookModel
  static BookModel domainToModel(BookDomain book) {
    return BookModel(
      objectId: (book.bookId ?? '').isNotEmpty ? book.bookId : null,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      title: book.title,
      subtitle: book.subtitle,
      isbn: book.isbn,
      description: book.description,
      language: book.language,
      status: book.status,
      publicationDate: book.publicationDate,
      pageCount: book.pageCount,
      contentRating: book.contentRating,
      rating: book.rating,
      thumbnail: book.thumbnailUrl,
    );
  }
}
