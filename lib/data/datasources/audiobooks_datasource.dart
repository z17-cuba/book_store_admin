import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/datasources/parse_base_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AudiobooksDatasource {
  AudiobooksDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<List<ParseBookModel>> getAllAudiobooks({
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger
          .i('Geting all audiobooks from library: $libraryId - skipping $skip');

      // Inner query to find books associated with the given library
      final QueryBuilder<ParseObject> bookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppBooks));
      bookQuery.whereEqualTo(
        'library',
        (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
      );

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppAudiobooks),
      );

      // Use the inner query to filter audiobooks
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
        final List<ParseBookModel> audiobooks = [];

        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Access the audiobook's book
          final ParseObject? book = parseObject.get<ParseObject>('book');

          if (book != null) {
            // Get relation data
            final List<ParseObject> tags =
                await ParseBaseDatasource.getRelationObjects(
              book,
              'tags',
            );
            final List<ParseObject> authors =
                await ParseBaseDatasource.getRelationObjects(
              book,
              'authors',
            );

            audiobooks.add(
              ParseBookModel(
                book: parseObject,
                authors: authors
                    .map((a) => AuthorModel.fromJson(a.toJson()))
                    .toList(),
                categories: [],
                tags: tags,
              ),
            );
          }
        }

        return audiobooks;
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllAudiobooks: $exception');
      throw CustomException(
        code: errorOnAudiobooksDatasource,
        errorMessage: 'getAllAudiobooks',
      );
    }
  }

  Future<ParseBookModel?> getAudiobookDetails({
    required String audiobookId,
  }) async {
    try {
      logger.i('Geting audiobook detail for $audiobookId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppAudiobooks),
      );

      // Include the related book data
      parseQuery.includeObject([
        'book',
        'book.publishers',
      ]);

      parseQuery.whereEqualTo(
        'objectId',
        audiobookId,
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        for (final parseObject in apiResponse.results as List<ParseObject>) {
          // Access the audiobook's book
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
              tags: tags,
            );
          }
        }
      }
      return null;
    } catch (exception) {
      logger.e('Error on getAudiobookDetails: $exception');
      throw CustomException(
        code: errorOnAudiobooksDatasource,
        errorMessage: 'getAudiobookDetails',
      );
    }
  }

  Future<ParseBookModel?> getAudiobookByBookId({
    required String bookId,
  }) async {
    try {
      logger.i('Getting audiobook for bookId: $bookId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppAudiobooks),
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
          // Access the audiobook's book
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
              tags: tags,
            );
          }
        }
      }
      return null;
    } catch (exception) {
      logger.e('Error on getAudiobookByBookId: $exception');
      throw CustomException(
        code: errorOnAudiobooksDatasource,
        errorMessage: 'getAudiobookByBookId',
      );
    }
  }

  Future<void> createAudiobook({
    required String bookId,
    ParseWebFile? mediaFile,
    String? fileFormat,
    String? narratorName,
    int? totalDurationSeconds,
    int? bitrate,
    int? sampleRate,
  }) async {
    try {
      final audiobookObject = ParseObject(back4AppAudiobooks)
        ..set('book', ParseObject(back4AppBooks)..objectId = bookId)
        ..set('file', mediaFile)
        ..set('fileFormat', fileFormat)
        ..set('narratorName', narratorName)
        ..set('totalDurationSeconds', totalDurationSeconds)
        ..set('sampleRate', sampleRate)
        ..set('bitrate', bitrate);

      await audiobookObject.save();

      logger.i('Audiobook created and linked to book ID: $bookId');
    } catch (exception) {
      logger.e('Error on createAudiobook: $exception');
      throw CustomException(
        code: errorOnAudiobooksDatasource,
        errorMessage: 'createAudiobook',
      );
    }
  }
}
