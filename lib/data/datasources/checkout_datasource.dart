import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/datasources/parse_base_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/data/models/parse_book_model.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CheckoutDatasource {
  CheckoutDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<int> getUserCheckoutsByLibraryCount(String libraryId) async {
    // Inner query to find books associated with the given library
    final QueryBuilder<ParseObject> bookQuery =
        QueryBuilder<ParseObject>(ParseObject(back4AppBooks));

    bookQuery.whereEqualTo(
      'library',
      (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
    );

    // Main query on ReadingProgress that uses the inner query
    final QueryBuilder<ParseObject> readingProgressQuery =
        QueryBuilder<ParseObject>(
      ParseObject(back4AppUserCheckouts),
    );
    readingProgressQuery.whereMatchesQuery('book', bookQuery);

    final ParseResponse apiResponse = await readingProgressQuery.count();

    if (apiResponse.success && apiResponse.result != null) {
      return apiResponse.count;
    } else {
      return 0;
    }
  }

  Future<(List<ParseBookModel>, List<int>)> getMostBoughtBooksByLibrary({
    required String libraryId,
    int limit = limitQueries,
  }) async {
    try {
      logger.i('Getting most bought books for library $libraryId');

      // Sub-query to get books for the library
      final QueryBuilder<ParseObject> bookQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppBooks))
            ..whereEqualTo(
              'library',
              (ParseObject(back4AppLibraries)..objectId = libraryId)
                  .toPointer(),
            );

      // Main query on UserCheckouts
      final QueryBuilder<ParseObject> checkoutQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppUserCheckouts))
            ..whereMatchesQuery('book', bookQuery);

      final ParseResponse response = await checkoutQuery.query();

      if (response.success && response.results != null) {
        final Map<String, int> bookCounts = {};
        for (final checkout in response.results as List<ParseObject>) {
          final bookPointer = checkout.get<ParseObject>('book');
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

          // Reorder based on sortedBooks and populate counts
          for (var sortedEntry in sortedBooks.take(limit)) {
            if (fetchedBooksMap.containsKey(sortedEntry.key)) {
              final bookObject = fetchedBooksMap[sortedEntry.key]!;
              final List<ParseObject> tags =
                  await ParseBaseDatasource.getRelationObjects(
                      bookObject, 'tags');
              final List<ParseObject> categories =
                  await ParseBaseDatasource.getRelationObjects(
                      bookObject, 'categories');
              final List<ParseObject> authors =
                  await ParseBaseDatasource.getRelationObjects(
                      bookObject, 'authors');

              orderedBooks.add(ParseBookModel(
                book: bookObject,
                authors: authors
                    .map((a) => AuthorModel.fromJson(a.toJson()))
                    .toList(),
                categories: categories
                    .map((c) => CategoryModel.fromJson(c.toJson()))
                    .toList(),
                tags: tags.map((c) => TagModel.fromJson(c.toJson())).toList(),
              ));
              orderedCounts.add(sortedEntry.value);
            }
          }
          return (orderedBooks, orderedCounts);
        }
      }

      return (<ParseBookModel>[], <int>[]);
    } catch (e) {
      logger.e('Error on getMostBoughtBooksByLibrary: $e');
      throw CustomException(
        code: errorOnCheckoutDatasource,
        errorMessage: 'getMostBoughtBooksByLibrary',
      );
    }
  }
}
