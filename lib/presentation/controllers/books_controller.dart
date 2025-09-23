import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/bindings/add_entities/add_author_binding.dart';
import 'package:book_store_admin/presentation/bindings/add_entities/add_publisher_binding.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_author_controller.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_publisher_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/dialogs/add_author_dialog.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/dialogs/add_publisher_dialog.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BooksController extends GetxController {
  BooksController({
    required this.bookRepository,
    required this.userController,
  });

  final BookRepository bookRepository;
  final UserController userController;

  // -> Books
  final RxList<BookDomain> booksByLibrary = <BookDomain>[].obs;
  final RxBool isLoadingBooks = true.obs;
  final RxBool noMoreBooks = false.obs;

  late BooksDataGridSource booksDataSource;
  final DataGridController dataGridController = DataGridController();
  // Pagination
  int skip = 0;

  // -> Categories
  final RxBool isLoadingCategories = true.obs;
  final RxInt pickedCategory = 0.obs;
  final RxList<CategoryDomain> categories = <CategoryDomain>[].obs;

  @override
  Future<void> onInit() async {
    booksDataSource = BooksDataGridSource(
      booksByLibrary: booksByLibrary,
      controller: this,
    );
    await Future.wait([
      loadCategories(),
      loadBooksByLibrary(),
    ]);
    super.onInit();
  }

  // Header and actions

  Future<void> addBook(BuildContext context) async {
    await NavigatorHelper.toNamed(
      Routes.createBook,
    );
  }

  Future<void> addAuthor(BuildContext context) async {
    AddAuthorBinding.init();

    await showDialog(
      context: context,
      builder: (context) => const AddAuthorDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<AddAuthorController>();
  }

  Future<void> addPublisher(BuildContext context) async {
    AddPublisherBinding.init();

    await showDialog(
      context: context,
      builder: (context) => const AddPublisherDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<AddPublisherController>();
  }

  Future<void> deleteBook(
    BuildContext context,
    int rowIndex,
  ) async {
    final bookToDelete = booksByLibrary[rowIndex];
    final bookId = bookToDelete.bookId;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('app.deleteBook'.tr),
          content: Text(
            'app.deleteBookWarning'.trParams({
              'title': bookToDelete.title ?? '',
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('app.cancel'.tr),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            PrimaryButton(
              expand: false,
              isFilled: true,
              color: AppColors.redError,
              textColor: Theme.of(context).canvasColor,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              title: 'app.deleteBook'.tr,
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (context.mounted) {
        LoadingOverlay.show(context: context);
      }
      try {
        final success = await bookRepository.deleteBook(bookId: bookId ?? '');
        if (success) {
          booksByLibrary.removeAt(rowIndex);
          booksDataSource.updateDataGridSource();
        }
      } finally {
        if (context.mounted) {
          LoadingOverlay.hide(context: context);
        }
      }
    }
  }

  Future<void> editBook(
    int rowIndex,
  ) async {
    await NavigatorHelper.toNamed(
      Routes.editBook,
      extra: booksByLibrary[rowIndex],
      pathParameters: {
        'bookId': booksByLibrary[rowIndex].bookId ?? '',
      },
    );
  }

  // Books table

  Future<void> loadBooksByLibrary({bool? shouldRefresh}) async {
    if (shouldRefresh != null && shouldRefresh) {
      skip = 0;
    }

    if (!noMoreBooks.value) {
      List<BookDomain> tempResult = await bookRepository.getAllBooksByLibrary(
        skip: skip,
        libraryId: userController.library?.objectId ?? '',
      );

      skip += limitQueries;
      noMoreBooks.value = tempResult.isEmpty;

      for (BookDomain book in tempResult) {
        if (!booksByLibrary.any((b) => b.bookId == book.bookId)) {
          booksByLibrary.add(book);
        }
      }
    }
    booksDataSource.updateDataGridSource();
    update();
    isLoadingBooks.value = false;
  }

  // Categories

  Future<void> loadCategories() async {
    final List<CategoryDomain> tempCategories =
        await bookRepository.getAllCategories();
    categories.assignAll(tempCategories);

    isLoadingCategories.value = false;
  }

  Future<void> pickCategory(int value) async {
    pickedCategory.value = value;
    isLoadingBooks.value = true;
    skip = 0;

    switch (value) {
      case 0:
        final allBooks = await bookRepository.getAllBooksByLibrary(
          skip: skip,
          libraryId: userController.library?.objectId ?? '',
        );
        // Shuffle between audiobooks and ebooks
        allBooks.shuffle();
        booksByLibrary.assignAll(allBooks);
        break;
      case 1:
        final eBooks = await bookRepository.getAllEbooks(
          skip: skip,
          libraryId: userController.library?.objectId ?? '',
        );
        booksByLibrary.assignAll(eBooks);
        break;
      case 2:
        final audioBooks = await bookRepository.getAllAudiobooks(
          skip: skip,
          libraryId: userController.library?.objectId ?? '',
        );
        booksByLibrary.assignAll(audioBooks);
        break;
      default:
        final String cat = categories[value - 3].id;
        final booksByCategory = await bookRepository.getBooksForCategory(
          skip: skip,
          categoryId: cat,
          libraryId: userController.library?.objectId ?? '',
        );
        booksByLibrary.assignAll(booksByCategory);
    }

    booksDataSource.updateDataGridSource();
    skip += limitQueries;
    update();
    isLoadingBooks.value = false;
  }
}

class BooksDataGridSource extends DataGridSource {
  BooksDataGridSource({
    required this.booksByLibrary,
    required this.controller,
  }) {
    _buildDataGridRows();
  }

  final List<BookDomain> booksByLibrary;
  List<DataGridRow> _books = [];

  @override
  List<DataGridRow> get rows => _books;
  final BooksController controller;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = rows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      if (dataCell.columnName == 'actions') {
        return Builder(builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'app.editBook'.tr,
                onPressed: () => controller.editBook(rowIndex),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBookEdit,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              IconButton(
                tooltip: 'app.deleteBook'.tr,
                onPressed: () => controller.deleteBook(context, rowIndex),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete01,
                  color: Colors.red,
                ),
              ),
            ],
          );
        });
      } else if (dataCell.columnName == 'type') {
        final BookType bookType = booksByLibrary[rowIndex].bookType;
        return bookType == BookType.audiobook
            ? const HugeIcon(
                icon: HugeIcons.strokeRoundedMusicNoteSquare01,
                color: AppColors.canvasColorWhite,
              )
            : bookType == BookType.ebook
                ? const HugeIcon(
                    icon: HugeIcons.strokeRoundedTablet02,
                    color: AppColors.canvasColorWhite,
                  )
                : const HugeIcon(
                    icon: HugeIcons.strokeRoundedFileUnknown,
                    color: AppColors.canvasColorWhite,
                  );
      } else {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            dataCell.value.toString(),
            style: textStyleBody,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    }).toList());
  }

  void updateDataGridSource() {
    _buildDataGridRows();
    notifyListeners();
  }

  void _buildDataGridRows() {
    _books = booksByLibrary
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'type',
                value: e.bookType.name,
              ),
              DataGridCell<String>(
                columnName: 'title',
                value: e.title ?? '',
              ),
              DataGridCell<String>(
                columnName: 'authors',
                value: e.authors?.map((a) => a.name).join(', ') ?? '',
              ),
              DataGridCell<String>(
                columnName: 'isbn',
                value: e.isbn ?? '',
              ),
              DataGridCell<String>(
                columnName: 'status',
                value: e.status != null ? 'app.${e.status}'.tr : '',
              ),
              // Is overriden with the Actions Row above
              const DataGridCell<String>(
                columnName: 'actions',
                value: 'actions',
              ),
            ],
          ),
        )
        .toList();
  }
}
