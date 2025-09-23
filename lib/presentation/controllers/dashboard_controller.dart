import 'package:book_store_admin/data/datasources/books_datasource.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/repositories/library_repository.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  DashboardController({
    required this.booksDatasource,
    required this.libraryRepository,
    required this.userController,
  });

  final BooksDatasource booksDatasource;
  final LibraryRepository libraryRepository;
  final UserController userController;

  final RxInt booksByLibrary = 0.obs;
  final RxInt readedBooksAmount = 0.obs;
  final RxInt boughtBooksAmount = 0.obs;

  final RxMap<BookDomain, int> mostReadedBooks = <BookDomain, int>{}.obs;
  final RxMap<BookDomain, int> mostBoughtBooks = <BookDomain, int>{}.obs;

  @override
  Future<void> onInit() async {
    await Future.wait(
      [
        loadBooksByLibrary(),
        loadMostReadedBooksByLibrary(),
        loadMostBoughtBooksByLibrary(),
      ],
    );

    super.onInit();
  }

  Future<void> navigateToMoreReadedBooks() async {
    // TODO
  }

  Future<void> navigateToMoreBoughtBooks() async {
    // TODO
  }

  Future<void> loadBooksByLibrary() async {
    booksByLibrary.value = await booksDatasource.getBooksByLibraryCount(
      userController.library?.objectId ?? '',
    );
  }

  Future<void> loadMostReadedBooksByLibrary() async {
    readedBooksAmount.value =
        await libraryRepository.getReadedBooksByLibraryCount(
      libraryId: userController.library?.objectId ?? '',
    );
    final (List<BookDomain>, List<int>) mostReadedBooksByLibrary =
        await libraryRepository.getMostReadedBooksByLibrary(
      libraryId: userController.library?.objectId ?? '',
    );

    for (var i = 0; i < mostReadedBooksByLibrary.$1.length; i++) {
      mostReadedBooks[mostReadedBooksByLibrary.$1[i]] =
          mostReadedBooksByLibrary.$2[i];
    }
  }

  Future<void> loadMostBoughtBooksByLibrary() async {
    boughtBooksAmount.value =
        await libraryRepository.getBoughtBooksByLibraryCount(
      libraryId: userController.library?.objectId ?? '',
    );

    final (books, amounts) =
        await libraryRepository.getMostBoughtBooksByLibrary(
      libraryId: userController.library?.objectId ?? '',
    );

    for (var i = 0; i < books.length; i++) {
      mostBoughtBooks[books[i]] = amounts[i];
    }
  }
}
