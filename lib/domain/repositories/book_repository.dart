import 'dart:typed_data';

import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/data/datasources/audiobooks_datasource.dart';
import 'package:book_store_admin/data/datasources/books_datasource.dart';
import 'package:book_store_admin/data/datasources/categories_datasource.dart';
import 'package:book_store_admin/data/datasources/ebooks_datasource.dart';
import 'package:book_store_admin/data/models/book_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/domain/mapper/book_mapper.dart';
import 'package:book_store_admin/domain/mapper/categories_mapper.dart';
import 'package:book_store_admin/domain/models/audiobook_domain.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';
import 'package:book_store_admin/domain/models/ebook_domain.dart';
import 'package:book_store_admin/domain/models/general_book_domain.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class BookRepository {
  BookRepository({
    required this.booksDatasource,
    required this.ebooksDatasource,
    required this.audiobooksDatasource,
    required this.categoriesDatasource,
  });

  final BooksDatasource booksDatasource;
  final EbooksDatasource ebooksDatasource;
  final AudiobooksDatasource audiobooksDatasource;
  final CategoriesDatasource categoriesDatasource;

  // Books
  Future<List<BookDomain>> getAllBooksByLibrary({
    int? skip,
    required String libraryId,
  }) async {
    final List<BookDomain> books = [];

    List<ParseBookModel> bookModels =
        await booksDatasource.getAllBooksByLibrary(
      skip: skip,
      libraryId: libraryId,
    );

    for (final bookParseObject in bookModels) {
      final String content = bookParseObject.book.parseClassName;
      BookDomain? bookDomain;

      switch (content) {
        case back4AppAudiobooks:
          bookDomain = BookMapper.parseAudiobookObjectToAudiobookDomain(
            bookParseObject,
          );
          break;
        case back4AppEbooks:
          bookDomain = BookMapper.parseEbookObjectToEbookDomain(
            bookParseObject,
          );
          break;
        default:
          bookDomain = BookMapper.parseBookObjectToGeneralBookDomain(
            bookParseObject,
          );
          break;
      }

      if (bookDomain != null) {
        books.add(bookDomain);
      }
    }

    return books;
  }

  Future<List<GeneralBookDomain>> searchBooks({
    int? skip,
    required String query,
    required String libraryId,
  }) async {
    final List<GeneralBookDomain> books = [];

    List<ParseBookModel> bookModels = await booksDatasource.searchBooks(
      skip: skip,
      query: query,
      libraryId: libraryId,
    );

    for (final bookParseObject in bookModels) {
      final GeneralBookDomain? bookDomain =
          BookMapper.parseBookObjectToGeneralBookDomain(
        bookParseObject,
      );

      if (bookDomain != null) {
        books.add(bookDomain);
      }
    }

    return books;
  }

  Future<List<GeneralBookDomain>> getBooksForCategory({
    required String categoryId,
    int? skip,
    required String libraryId,
  }) async {
    final List<GeneralBookDomain> books = [];

    List<ParseBookModel> bookModels = await booksDatasource.getBooksForCategory(
      skip: skip,
      categoryId: categoryId,
      libraryId: libraryId,
    );

    for (final bookParseObject in bookModels) {
      final GeneralBookDomain? bookDomain =
          BookMapper.parseBookObjectToGeneralBookDomain(
        bookParseObject,
      );

      if (bookDomain != null) {
        books.add(bookDomain);
      }
    }

    return books;
  }

  Future<GeneralBookDomain?> getBookDetails({
    required String bookId,
  }) async {
    ParseBookModel? bookModel = await booksDatasource.getBookDetails(
      bookId: bookId,
    );

    if (bookModel != null) {
      final GeneralBookDomain? bookDomain =
          BookMapper.parseBookObjectToGeneralBookDomain(
        bookModel,
      );

      return bookDomain;
    } else {
      return null;
    }
  }

  Future<bool> deleteBook({
    required String bookId,
  }) async {
    bool response = await booksDatasource.deleteBook(
      bookId: bookId,
    );

    return response;
  }

  Future<bool> createOrUpdateBook({
    required BookDomain book,
    required List<String> authorIds,
    required List<String> categoriesIds,
    required List<String> tagsIds,
    required String libraryId,
    required BookType bookType,
    Uint8List? photoBytes,
    String? publisherId,
    // Ebook / Audiobook specific fields
    Uint8List? mediaBytes,
    String? fileFormat,
    double? fileSizeMb,
    String? narratorName,
    int? totalDurationSeconds,
    int? bitrate,
    int? sampleRate,
  }) async {
    String? bookId;
    final BookModel bookModel = BookMapper.domainToModel(book);

    if (book.bookId == null) {
      bookId = await booksDatasource.createBook(
        bookModel: bookModel,
        photoBytes: photoBytes,
        libraryId: libraryId,
        bookType: book.bookType,
        publisherId: publisherId,
      );
    } else {
      bookId = book.bookId;
      await booksDatasource.updateBook(
        bookModel: bookModel,
        photoBytes: photoBytes,
        libraryId: libraryId,
        bookType: book.bookType,
        publisherId: publisherId,
      );
    }

    if (bookId != null && bookId.isNotEmpty) {
      // Remove book relations
      await booksDatasource.removeBookRelations(
        bookId: bookId,
      );

      // Update book relations
      await booksDatasource.updateBookRelations(
        bookId: bookId,
        authorIds: authorIds,
        categoriesIds: categoriesIds,
        tagsIds: tagsIds,
      );

      // Create Ebook or Audiobook if media is provided
      if (mediaBytes != null) {
        final mediaFile = ParseWebFile(
          mediaBytes,
          name:
              '${bookModel.title?.removeAllWhitespace ?? bookId}_${book.bookType.name}',
        );

        switch (bookType) {
          case BookType.ebook:
            await ebooksDatasource.createEbook(
              bookId: bookId,
              mediaFile: mediaFile,
              fileFormat: fileFormat,
              fileSizeMb: fileSizeMb,
            );
            break;
          case BookType.audiobook:
            await audiobooksDatasource.createAudiobook(
              bookId: bookId,
              mediaFile: mediaFile,
              fileFormat: fileFormat,
              narratorName: narratorName,
              totalDurationSeconds: totalDurationSeconds,
              bitrate: bitrate,
              sampleRate: sampleRate,
            );
            break;
          case BookType.book:
            // No associated media file for a standard book
            break;
        }
      }

      return true;
    } else {
      return false;
    }
  }

  // Ebooks
  Future<List<EbookDomain>> getAllEbooks({
    int? skip,
    required String libraryId,
  }) async {
    final List<EbookDomain> ebooks = [];

    List<ParseBookModel> ebookModels = await ebooksDatasource.getAllEbooks(
      skip: skip,
      libraryId: libraryId,
    );

    for (final ebookParseObject in ebookModels) {
      final EbookDomain? ebookDomain = BookMapper.parseEbookObjectToEbookDomain(
        ebookParseObject,
      );
      if (ebookDomain != null) {
        ebooks.add(ebookDomain);
      }
    }

    return ebooks;
  }

  Future<EbookDomain?> getEbookDetails({
    required String ebookId,
  }) async {
    ParseBookModel? ebookModel = await ebooksDatasource.getEbookDetails(
      ebookId: ebookId,
    );

    if (ebookModel != null) {
      final EbookDomain? ebookDomain = BookMapper.parseEbookObjectToEbookDomain(
        ebookModel,
      );
      return ebookDomain;
    } else {
      return null;
    }
  }

  // Audiobooks
  Future<List<AudiobookDomain>> getAllAudiobooks({
    int? skip,
    required String libraryId,
  }) async {
    final List<AudiobookDomain> audiobooks = [];

    List<ParseBookModel> audiobookModels =
        await audiobooksDatasource.getAllAudiobooks(
      skip: skip,
      libraryId: libraryId,
    );

    for (final audiobookParseObject in audiobookModels) {
      final AudiobookDomain? audiobookDomain =
          BookMapper.parseAudiobookObjectToAudiobookDomain(
        audiobookParseObject,
      );
      if (audiobookDomain != null) {
        audiobooks.add(audiobookDomain);
      }
    }

    return audiobooks;
  }

  Future<AudiobookDomain?> getAudiobookDetails({
    required String audiobookId,
  }) async {
    ParseBookModel? audiobookModel =
        await audiobooksDatasource.getAudiobookDetails(
      audiobookId: audiobookId,
    );

    if (audiobookModel != null) {
      final AudiobookDomain? ebookDomain =
          BookMapper.parseAudiobookObjectToAudiobookDomain(
        audiobookModel,
      );
      return ebookDomain;
    } else {
      return null;
    }
  }

  // Categories
  Future<List<CategoryDomain>> getAllCategories() async {
    final List<CategoryDomain> categories = [];

    final List<CategoryModel> categoriesModels =
        await categoriesDatasource.getAllCategories();

    for (final categoryModel in categoriesModels) {
      final CategoryDomain categoryDomain =
          CategoriesMapper.categoryToDomain(categoryModel);

      categories.add(categoryDomain);
    }

    categories.sort(
      (a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0),
    );

    return categories;
  }
}
