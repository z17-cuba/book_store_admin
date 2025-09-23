import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/data/datasources/checkout_datasource.dart';
import 'package:book_store_admin/data/datasources/reading_progress_datasource.dart';
import 'package:book_store_admin/domain/mapper/book_mapper.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';

class LibraryRepository {
  LibraryRepository({
    required this.bookRepository,
    required this.readingProgressDatasource,
    required this.checkoutDatasource,
  });

  final BookRepository bookRepository;
  final CheckoutDatasource checkoutDatasource;
  final ReadingProgressDatasource readingProgressDatasource;

  Future<int> getReadedBooksByLibraryCount({
    required String libraryId,
  }) async {
    return await readingProgressDatasource.getReadedBooksByLibraryCount(
      libraryId,
    );
  }

  Future<int> getBoughtBooksByLibraryCount({
    required String libraryId,
  }) async {
    return await checkoutDatasource.getUserCheckoutsByLibraryCount(
      libraryId,
    );
  }

  Future<(List<BookDomain>, List<int>)> getMostReadedBooksByLibrary({
    required String libraryId,
    bool? finished,
  }) async {
    final (bookModels, amounts) =
        await readingProgressDatasource.getMostReadedBooksByLibrary(
      libraryId: libraryId,
      finished: finished,
    );

    final List<BookDomain> books = [];
    for (final bookModel in bookModels) {
      final bookDomain =
          BookMapper.parseBookObjectToGeneralBookDomain(bookModel);
      if (bookDomain != null) {
        books.add(bookDomain);
      }
    }

    return (books, amounts);
  }

  Future<(List<BookDomain>, List<int>)> getMostBoughtBooksByLibrary({
    required String libraryId,
  }) async {
    final (bookModels, amounts) =
        await checkoutDatasource.getMostBoughtBooksByLibrary(
      libraryId: libraryId,
    );

    final List<BookDomain> books = [];
    for (final bookModel in bookModels) {
      final bookDomain =
          BookMapper.parseBookObjectToGeneralBookDomain(bookModel);
      if (bookDomain != null) {
        books.add(bookDomain);
      }
    }

    return (books, amounts);
  }

  Future<BookDomain?> getBookDomain(
    String bookId,
    String contentId,
    String contentType,
    double? progressPercentage,
  ) async {
    if (contentType == BookType.audiobook.name) {
      // 1. Try Audiobook
      return await bookRepository.getAudiobookDetails(
        audiobookId: contentId,
      );
    } else if (contentType == BookType.ebook.name) {
      // 2. Try Ebook
      return await bookRepository.getEbookDetails(
        ebookId: contentId,
      );
    } else {
      // 3. Try General Book
      return await bookRepository.getBookDetails(
        bookId: bookId,
      );
    }
  }
}
