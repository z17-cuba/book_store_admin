import 'dart:typed_data';

import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/data/datasources/audiobooks_datasource.dart';
import 'package:book_store_admin/data/datasources/ebooks_datasource.dart';
import 'package:book_store_admin/data/datasources/parse_base_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/book_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class BooksDatasource {
  BooksDatasource({
    required this.parse,
    required this.logger,
    required this.ebooksDatasource,
    required this.audiobooksDatasource,
  });

  final Parse parse;
  final Logger logger;
  final EbooksDatasource ebooksDatasource;
  final AudiobooksDatasource audiobooksDatasource;

  Future<List<ParseBookModel>> getAllBooksByLibrary({
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger.i('Getting all books from library $libraryId - skipping $skip');

      // 1. Fetch the base 'Book' objects for the library with pagination
      final QueryBuilder<ParseObject> parseQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppBooks))
            ..whereEqualTo(
              'library',
              ParseObject(back4AppLibraries)..objectId = libraryId,
            )
            ..setLimit(limitQueries)
            ..includeObject(['publishers']); // Include publishers early

      if (skip != null) {
        parseQuery.setAmountToSkip(skip);
      }

      final baseBooksResponse = await parseQuery.query();

      if (!baseBooksResponse.success || baseBooksResponse.results == null) {
        return [];
      }

      final baseBooks = baseBooksResponse.results as List<ParseObject>;
      if (baseBooks.isEmpty) {
        return [];
      }

      // 2. Fetch all related Ebooks and Audiobooks in parallel
      final bookPointers = baseBooks.map((b) => b.toPointer()).toList();

      final ebookQuery = QueryBuilder<ParseObject>(ParseObject(back4AppEbooks))
        ..whereContainedIn('book', bookPointers)
        ..includeObject(
          ['book', 'book.publishers'],
        );
      final audiobookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppAudiobooks))
            ..whereContainedIn('book', bookPointers)
            ..includeObject(['book', 'book.publishers']);

      final [ebookResponse, audiobookResponse] =
          await Future.wait([ebookQuery.query(), audiobookQuery.query()]);

      // 3. Map the results for efficient lookup
      final Map<String, ParseObject> ebooksMap = {
        for (var e in (ebookResponse.results ?? []))
          (e.get<ParseObject>('book'))!.objectId!: e
      };
      final Map<String, ParseObject> audiobooksMap = {
        for (var a in (audiobookResponse.results ?? []))
          (a.get<ParseObject>('book'))!.objectId!: a
      };

      // 4. Construct the final list of ParseBookModels
      final List<ParseBookModel> books = [];
      for (final bookObject in baseBooks) {
        final bookId = bookObject.objectId!;
        final hasEbook = ebooksMap.containsKey(bookId);
        final hasAudiobook = audiobooksMap.containsKey(bookId);

        // Determine which object to use (Ebook/Audiobook takes precedence for class name)
        final representativeObject = hasEbook
            ? ebooksMap[bookId]!
            : hasAudiobook
                ? audiobooksMap[bookId]!
                : bookObject;

        // Fetch relations for the base book object
        final [authors, categories, tags] = await Future.wait([
          ParseBaseDatasource.getRelationObjects(bookObject, 'authors'),
          ParseBaseDatasource.getRelationObjects(bookObject, 'categories'),
          ParseBaseDatasource.getRelationObjects(bookObject, 'tags'),
        ]);

        books.add(
          ParseBookModel(
            book: representativeObject,
            authors:
                authors.map((a) => AuthorModel.fromJson(a.toJson())).toList(),
            categories: categories
                .map((c) => CategoryModel.fromJson(c.toJson()))
                .toList(),
            tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
          ),
        );
      }

      return books;
    } catch (exception) {
      logger.e('Error on getAllBooksByLibrary: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'getAllBooksByLibrary',
      );
    }
  }

  Future<int> getBooksByLibraryCount(
    String libraryId,
  ) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(back4AppBooks))
          ..whereEqualTo(
            'library',
            ParseObject(back4AppLibraries)..objectId = libraryId,
          );

    final ParseResponse apiResponse = await query.count();

    if (apiResponse.success && apiResponse.result != null) {
      return apiResponse.count;
    } else {
      return 0;
    }
  }

  Future<List<ParseBookModel>> searchBooks({
    int? skip,
    required String query,
    required String libraryId,
  }) async {
    try {
      logger.i(
          'Searching all books from library $libraryId with query $query - skipping $skip');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppBooks),
      );

      parseQuery.setLimit(limitQueries);
      if (skip != null) {
        parseQuery.setAmountToSkip(skip);
      }

      parseQuery.whereContains('title', query);

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        final List<ParseBookModel> books = [];

        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Ebooks
          ParseBookModel? ebook = await ebooksDatasource.getEbookByBookId(
            bookId: parseObject.objectId!,
          );

          if (ebook != null) {
            books.add(ebook);
          }

          // Audiobooks
          ParseBookModel? audiobook =
              await audiobooksDatasource.getAudiobookByBookId(
            bookId: parseObject.objectId!,
          );

          if (audiobook != null) {
            books.add(audiobook);
          }
        }

        return books;
      }
      return [];
    } catch (exception) {
      logger.e('Error on searchBooks: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'searchBooks',
      );
    }
  }

  /// Query for books that have the specific category in their Category relation
  Future<List<ParseBookModel>> getBooksForCategory({
    required String categoryId,
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger.i(
          'Geting all books from library $libraryId from category $categoryId - skipping $skip');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppBooks),
      );

      final QueryBuilder<ParseObject> categoryQuery =
          QueryBuilder<ParseObject>(ParseObject('Categories'))
            ..whereEqualTo('objectId', categoryId);

      parseQuery.setLimit(limitQueries);
      if (skip != null) {
        parseQuery.setAmountToSkip(skip);
      }
      parseQuery.whereMatchesQuery('categories', categoryQuery);

      // Category query here

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        final List<ParseBookModel> books = [];

        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Get relation data
          final List<ParseObject> tags =
              await ParseBaseDatasource.getRelationObjects(
            parseObject,
            'tags',
          );
          final List<ParseObject> authors =
              await ParseBaseDatasource.getRelationObjects(
            parseObject,
            'authors',
          );

          books.add(
            ParseBookModel(
              book: parseObject,
              authors:
                  authors.map((a) => AuthorModel.fromJson(a.toJson())).toList(),
              categories: [],
              tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
            ),
          );
        }

        return books;
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllBooks: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'getAllBooks',
      );
    }
  }

  Future<ParseBookModel?> getBookDetails({
    required String bookId,
  }) async {
    try {
      logger.i('Geting book detail for $bookId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppBooks),
      );

      // Include the related book data
      parseQuery.includeObject([
        'book.publishers',
      ]);

      parseQuery.whereEqualTo(
        'objectId',
        bookId,
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        for (final book in apiResponse.results as List<ParseObject>) {
          // Get relation data
          final List<ParseObject> tags =
              await ParseBaseDatasource.getRelationObjects(
            book,
            'tags',
          );
          final List<ParseObject> categories =
              await ParseBaseDatasource.getRelationObjects(
            book,
            'categories',
          );
          final List<ParseObject> authors =
              await ParseBaseDatasource.getRelationObjects(
            book,
            'authors',
          );

          return ParseBookModel(
            book: book,
            authors:
                authors.map((a) => AuthorModel.fromJson(a.toJson())).toList(),
            categories: categories
                .map((c) => CategoryModel.fromJson(c.toJson()))
                .toList(),
            tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
          );
        }
      }
      return null;
    } catch (exception) {
      logger.e('Error on getBookDetails: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'getBookDetails',
      );
    }
  }

  Future<bool> deleteBook({required String bookId}) async {
    try {
      logger.i('Attempting to delete book with id: $bookId');

      final bookPointer =
          (ParseObject(back4AppBooks)..objectId = bookId).toPointer();

      // 1. Find and delete associated Ebooks
      final ebookQuery = QueryBuilder<ParseObject>(ParseObject(back4AppEbooks))
        ..whereEqualTo('book', bookPointer);
      final ebookResponse = await ebookQuery.query();

      if (ebookResponse.success && ebookResponse.results != null) {
        for (var ebook in ebookResponse.results as List<ParseObject>) {
          logger.i('Deleting associated ebook: ${ebook.objectId}');
          await ebook.delete();
        }
      }

      // 2. Find and delete associated Audiobooks
      final audiobookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppAudiobooks))
            ..whereEqualTo('book', bookPointer);
      final audiobookResponse = await audiobookQuery.query();

      if (audiobookResponse.success && audiobookResponse.results != null) {
        for (var audiobook in audiobookResponse.results as List<ParseObject>) {
          logger.i('Deleting associated audiobook: ${audiobook.objectId}');
          await audiobook.delete();
        }
      }

      // 3. Delete the main Book object
      final bookObject = ParseObject(back4AppBooks)..objectId = bookId;
      final deleteResponse = await bookObject.delete();

      if (deleteResponse.success) {
        logger.i('Successfully deleted book: $bookId');
        return true;
      } else {
        logger.e(
            'Failed to delete book $bookId: ${deleteResponse.error?.message}');
        return false;
      }
    } catch (e) {
      logger.e('Error on deleteBook: $e');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'deleteBook',
      );
    }
  }

  Future<String?> createBook({
    required BookModel bookModel,
    required String libraryId,
    required BookType bookType,
    String? publisherId,
    Uint8List? photoBytes,
  }) async {
    try {
      logger.i('Creating new book ${bookModel.toString()}');

      ParseFileBase parseFile;

      final ParseObject bookModelObject = ParseObject(back4AppBooks)
        ..set('title', bookModel.title)
        ..set('subtitle', bookModel.subtitle)
        ..set('isbn', bookModel.isbn)
        ..set('description', bookModel.description)
        ..set('status', bookModel.status)
        ..set('language', bookModel.language)
        ..set('pageCount', bookModel.pageCount)
        ..set('contentRating', bookModel.contentRating)
        ..set('library', ParseObject(back4AppLibraries)..objectId = libraryId)
        ..set('publisher',
            ParseObject(back4AppPublishers)..objectId = publisherId);

      if (photoBytes != null) {
        parseFile = ParseWebFile(
          photoBytes,
          name: '${bookModel.title ?? ''}_thumbnail',
        );

        bookModelObject.set("thumbnail", parseFile);
      }

      final ParseResponse apiResponse = await bookModelObject.save();

      if (apiResponse.success && bookModelObject.objectId != null) {
        logger.i(
            'Book created successfully with ID: ${bookModelObject.objectId}');

        return bookModelObject.objectId;
      } else {
        logger.e('Failed to create book: ${apiResponse.error}');
        return null;
      }
    } catch (exception) {
      logger.e('Error on createBook: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'createBook',
      );
    }
  }

  Future<String?> updateBook({
    required BookModel bookModel,
    required String libraryId,
    required BookType bookType,
    String? publisherId,
    Uint8List? photoBytes,
  }) async {
    try {
      logger.i('Updating new book ${bookModel.toString()}');

      ParseFileBase parseFile;

      final ParseObject bookModelObject = ParseObject(back4AppBooks)
        ..objectId = bookModel.objectId
        ..set('title', bookModel.title)
        ..set('subtitle', bookModel.subtitle)
        ..set('isbn', bookModel.isbn)
        ..set('description', bookModel.description)
        ..set('status', bookModel.status)
        ..set('language', bookModel.language)
        ..set('pageCount', bookModel.pageCount)
        ..set('contentRating', bookModel.contentRating)
        ..set('library', ParseObject(back4AppLibraries)..objectId = libraryId)
        ..set('publisher',
            ParseObject(back4AppPublishers)..objectId = publisherId);

      if (photoBytes != null) {
        parseFile = ParseWebFile(
          photoBytes,
          name: '${bookModel.title ?? ''}_thumbnail',
        );

        bookModelObject.set("thumbnail", parseFile);
      }

      final ParseResponse apiResponse = await bookModelObject.save();

      if (apiResponse.success && bookModelObject.objectId != null) {
        logger.i(
            'Book updated successfully with ID: ${bookModelObject.objectId}');

        return bookModelObject.objectId;
      } else {
        logger.e('Failed to update book: ${apiResponse.error}');
        return null;
      }
    } catch (exception) {
      logger.e('Error on updateBook: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'updateBook',
      );
    }
  }

  Future<void> updateBookRelations({
    required String bookId,
    required List<String> authorIds,
    required List<String> categoriesIds,
    required List<String> tagsIds,
  }) async {
    try {
      logger.i('Updating relations for book $bookId');

      final ParseObject bookModelObject =
          (ParseObject(back4AppBooks)..objectId = bookId);

      // Add Authors relation
      final ParseRelation<ParseObject> authorsRelation =
          bookModelObject.getRelation('authors');
      for (String authorId in authorIds) {
        authorsRelation.add(
          ParseObject(back4AppAuthors)..objectId = authorId,
        );
      }

      // Add Categories relation
      final ParseRelation<ParseObject> categoriesRelation =
          bookModelObject.getRelation('categories');
      for (String categoryId in categoriesIds) {
        categoriesRelation.add(
          ParseObject(back4AppCategories)..objectId = categoryId,
        );
      }

      // Add Tags relation
      final ParseRelation<ParseObject> tagsRelation =
          bookModelObject.getRelation('tags');
      for (String tagId in tagsIds) {
        tagsRelation.add(
          ParseObject(back4AppTags)..objectId = tagId,
        );
      }
    } catch (exception) {
      logger.e('Error on updateBookRelations: $exception');
      throw CustomException(
        code: errorOnBooksDatasource,
        errorMessage: 'updateBookRelations',
      );
    }
  }
}
