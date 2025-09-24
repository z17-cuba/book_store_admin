import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/datasources/parse_base_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class EbooksDatasource {
  EbooksDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<List<ParseBookModel>> getAllEbooks({
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger.i('Geting all ebooks from library: $libraryId - skipping $skip');

      // Inner query to find books associated with the given library
      final QueryBuilder<ParseObject> bookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppBooks));
      bookQuery.whereEqualTo(
        'library',
        (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
      );

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppEbooks),
      );

      // Use the inner query to filter ebooks
      parseQuery.whereMatchesQuery('book', bookQuery);

      // Include the related book data
      parseQuery.includeObject([
        'book',
        'book.publishers',
      ]);

      parseQuery.setLimit(limitQueries);
      if (skip != null) {
        parseQuery.setAmountToSkip(skip);
      }
      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        final List<ParseBookModel> ebooks = [];

        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Access the ebook's book
          final ParseObject? book = parseObject.get<ParseObject>('book');

          if (book != null) {
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

            ebooks.add(
              ParseBookModel(
                book: parseObject,
                authors: authors
                    .map((a) => AuthorModel.fromJson(a.toJson()))
                    .toList(),
                categories: categories
                    .map((c) => CategoryModel.fromJson(c.toJson()))
                    .toList(),
                tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
              ),
            );
          }
        }

        return ebooks;
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllEbooks: $exception');
      throw CustomException(
        code: errorOnEbooksDatasource,
        errorMessage: 'getAllEbooks',
      );
    }
  }

  Future<ParseBookModel?> getEbookDetails({
    required String ebookId,
  }) async {
    try {
      logger.i('Geting ebook detail for $ebookId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppEbooks),
      );

      // Include the related book data
      parseQuery.includeObject([
        'book',
        'book.publishers',
      ]);

      parseQuery.whereEqualTo(
        'objectId',
        ebookId,
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Access the ebook's book
          final ParseObject? book = parseObject.get<ParseObject>('book');

          if (book != null) {
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
              book: parseObject,
              authors:
                  authors.map((a) => AuthorModel.fromJson(a.toJson())).toList(),
              categories: categories
                  .map((c) => CategoryModel.fromJson(c.toJson()))
                  .toList(),
              tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
            );
          }
        }
      }
      return null;
    } catch (exception) {
      logger.e('Error on getEbookDetails: $exception');
      throw CustomException(
        code: errorOnEbooksDatasource,
        errorMessage: 'getEbookDetails',
      );
    }
  }

  Future<ParseBookModel?> getEbookByBookId({
    required String bookId,
  }) async {
    try {
      logger.i('Getting ebook for bookId: $bookId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppEbooks),
      );

      // Include the related book data
      parseQuery.includeObject([
        'book',
      ]);

      // Query by book pointer
      parseQuery.whereEqualTo(
        'book',
        ParseObject(back4AppBooks)..objectId = bookId,
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Access the ebook's book
          final ParseObject? book = parseObject.get<ParseObject>('book');

          if (book != null) {
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
              book: parseObject,
              authors:
                  authors.map((a) => AuthorModel.fromJson(a.toJson())).toList(),
              categories: categories
                  .map((c) => CategoryModel.fromJson(c.toJson()))
                  .toList(),
              tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
            );
          }
        }
      }
      return null;
    } catch (exception) {
      logger.e('Error on getEbookByBookId: $exception');
      throw CustomException(
        code: errorOnEbooksDatasource,
        errorMessage: 'getEbookByBookId',
      );
    }
  }

  Future<void> createEbook({
    required String bookId,
    ParseWebFile? mediaFile,
    String? fileFormat,
    double? fileSizeMb,
  }) async {
    try {
      final ebookObject = ParseObject(back4AppEbooks)
        ..set('book', ParseObject(back4AppBooks)..objectId = bookId)
        ..set('file', mediaFile)
        ..set('fileFormat', fileFormat)
        ..set('fileSizeMb', fileSizeMb);

      await ebookObject.save();

      logger.i('Ebook created and linked to book ID: $bookId');
    } catch (exception) {
      logger.e('Error on createEbook: $exception');
      throw CustomException(
        code: errorOnEbooksDatasource,
        errorMessage: 'createEbook',
      );
    }
  }
}
