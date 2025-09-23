import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/datasources/parse_base_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ReadingProgressDatasource {
  ReadingProgressDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<int> getReadedBooksByLibraryCount(
    String libraryId,
  ) async {
    // Get all unique book pointers from ReadingProgress
    final QueryBuilder<ParseObject> readingProgressQuery =
        QueryBuilder<ParseObject>(
      ParseObject(back4AppReadingProgress),
    );

    final ParseResponse apiResponse =
        await readingProgressQuery.distinct('book');

    if (apiResponse.success && apiResponse.results != null) {
      final List<dynamic> bookPointers = apiResponse.results!;
      if (bookPointers.isEmpty) {
        return 0;
      }

      final List<String> bookIds = bookPointers
          .map((pointer) => (pointer as ParseObject).objectId)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      // Now, count how many of these books belong to the specified library.
      final QueryBuilder<ParseObject> bookQuery = QueryBuilder<ParseObject>(
          ParseObject(back4AppBooks))
        ..whereContainedIn('objectId', bookIds)
        ..whereEqualTo('library',
            (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer());

      final ParseResponse countResponse = await bookQuery.count();
      return countResponse.success ? countResponse.count : 0;
    } else {
      logger.e(
          'Error counting read books: ${apiResponse.error?.message ?? "Unknown error"}');
      return 0;
    }
  }

  Future<(List<ParseBookModel>, List<int>)> getMostReadedBooksByLibrary({
    required String libraryId,
    int limit = limitQueries,
    bool? finished,
  }) async {
    try {
      logger.i('Getting most read books for library $libraryId');

      // Sub-query to get books for the library
      final QueryBuilder<ParseObject> bookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppBooks))
            ..whereEqualTo(
              'library',
              (ParseObject(back4AppLibraries)..objectId = libraryId)
                  .toPointer(),
            );

      // Main query on ReadingProgress
      final QueryBuilder<ParseObject> readingProgressQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppReadingProgress))
            ..whereMatchesQuery('book', bookQuery);

      if (finished != null) {
        readingProgressQuery.whereEqualTo('isCompleted', finished);
      }

      final ParseResponse response = await readingProgressQuery.query();

      if (response.success && response.results != null) {
        final Map<String, int> bookCounts = {};
        for (final progress in response.results as List<ParseObject>) {
          final bookPointer = progress.get<ParseObject>('book');
          if (bookPointer != null) {
            final bookId = bookPointer.objectId!;
            bookCounts[bookId] = (bookCounts[bookId] ?? 0) + 1;
          }
        }

        final sortedBooks = bookCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topBookIds =
            sortedBooks.take(limit).map((entry) => entry.key).toList();

        if (topBookIds.isEmpty) {
          return (<ParseBookModel>[], <int>[]);
        }

        // Fetch book details for the top books
        final QueryBuilder<ParseObject> topBooksQuery =
            QueryBuilder<ParseObject>(ParseObject(back4AppBooks))
              ..whereContainedIn('objectId', topBookIds)
              ..includeObject(['publishers']);

        final booksResponse = await topBooksQuery.query();

        if (booksResponse.success && booksResponse.results != null) {
          final List<ParseBookModel> orderedBooks = [];
          final List<int> orderedCounts = [];
          final Map<String, ParseObject> fetchedBooksMap = {
            for (var book in booksResponse.results as List<ParseObject>)
              book.objectId!: book
          };
          for (final bookObject in booksResponse.results as List<ParseObject>) {
            final List<ParseObject> tags =
                await ParseBaseDatasource.getRelationObjects(
                    bookObject, 'tags');
            final List<ParseObject> categories =
                await ParseBaseDatasource.getRelationObjects(
                    bookObject, 'categories');
            final List<ParseObject> authors =
                await ParseBaseDatasource.getRelationObjects(
                    bookObject, 'authors');

            // Reorder based on sortedBooks and populate counts
            for (var sortedEntry in sortedBooks.take(limit)) {
              if (fetchedBooksMap.containsKey(sortedEntry.key)) {
                final bookObject = fetchedBooksMap[sortedEntry.key]!;
                orderedBooks.add(
                  ParseBookModel(
                    book: bookObject,
                    authors: authors
                        .map((a) => AuthorModel.fromJson(a.toJson()))
                        .toList(),
                    categories: categories
                        .map((c) => CategoryModel.fromJson(c.toJson()))
                        .toList(),
                    tags: tags,
                  ),
                );
                orderedCounts.add(sortedEntry.value);
                // Remove to avoid duplicates if a book is processed multiple times
                fetchedBooksMap.remove(sortedEntry.key);
              }
            }
          }
          return (orderedBooks, orderedCounts);
        }
      }

      return (<ParseBookModel>[], <int>[]);
    } catch (e) {
      logger.e('Error on getMostReadedBooksByLibrary: $e');
      throw CustomException(
        code: errorOnReadingProgressDatasource,
        errorMessage: 'getMostReadedBooksByLibrary',
      );
    }
  }
}
