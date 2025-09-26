import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/bindings/add_entities/add_edit_author_binding.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_author_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/dialogs/add_edit_author_dialog.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AuthorsController extends GetxController {
  AuthorsController({
    required this.authorRepository,
    required this.userController,
  });

  final AuthorRepository authorRepository;
  final UserController userController;

  // -> Authors
  final RxList<AuthorDomain> authorsByLibrary = <AuthorDomain>[].obs;
  final RxBool isLoadingAuthors = true.obs;
  final RxBool noMoreAuthors = false.obs;

  late AuthorsDataGridSource authorsDataGridSource;
  final DataGridController dataGridController = DataGridController();
  // Pagination
  int skip = 0;

  @override
  Future<void> onInit() async {
    authorsDataGridSource = AuthorsDataGridSource(
      authors: authorsByLibrary,
      controller: this,
    );
    await loadAuthorsByLibrary();
    super.onInit();
  }

  Future<void> addEditAuthor(
    BuildContext context,
    AuthorDomain? authorDomain,
  ) async {
    AddEditAuthorBinding.init(authorDomain);

    await showDialog(
      context: context,
      builder: (context) => const AddEditAuthorDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<AddEditAuthorController>();
  }

  Future<void> deleteAuthor(
    BuildContext context,
    String authorId,
    String authorName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('app.deleteAuthor'.tr),
          content: Text(
            'app.deleteAuthorWarning'.trParams({
              'title': authorName,
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
              title: 'app.deleteAuthor'.tr,
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
        final success = await authorRepository.deleteAuthor(authorId: authorId);
        if (success) {
          authorsByLibrary.removeWhere((author) => author.id == authorId);
          authorsDataGridSource.updateDataGridSource();
        }
      } finally {
        if (context.mounted) {
          LoadingOverlay.hide(context: context);
        }
      }
    }
  }

  Future<void> loadAuthorsByLibrary({bool? shouldRefresh}) async {
    if (shouldRefresh != null && shouldRefresh) {
      skip = 0;
      noMoreAuthors.value = false;
    }

    if (!noMoreAuthors.value) {
      List<AuthorDomain> tempResult =
          await authorRepository.getAllAuthorsByLibrary(
        skip: skip,
        libraryId: userController.library?.objectId ?? '',
      );

      skip += limitQueries;
      noMoreAuthors.value = tempResult.isEmpty;

      for (AuthorDomain author in tempResult) {
        final bool hasAuthor = authorsByLibrary.any((t) => t.id == author.id);
        if (!hasAuthor) {
          authorsByLibrary.add(author);
        } else if (hasAuthor &&
            author.fullName !=
                authorsByLibrary
                    .firstWhere((t) => t.id == author.id)
                    .fullName) {
          final int authorIndex =
              authorsByLibrary.indexWhere((t) => t.id == author.id);
          authorsByLibrary[authorIndex] = author;
        }
      }
    }
    authorsDataGridSource.updateDataGridSource();
    update();
    isLoadingAuthors.value = false;
  }
}

class AuthorsDataGridSource extends DataGridSource {
  AuthorsDataGridSource({
    required this.authors,
    required this.controller,
  }) {
    _buildDataGridRows();
  }

  final List<AuthorDomain> authors;
  List<DataGridRow> _authors = [];

  @override
  List<DataGridRow> get rows => _authors;
  final AuthorsController controller;

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
                tooltip: 'app.editAuthor'.tr,
                onPressed: () => controller.addEditAuthor(
                  context,
                  authors[rowIndex],
                ),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBookEdit,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              IconButton(
                tooltip: 'app.deleteAuthor'.tr,
                onPressed: () => controller.deleteAuthor(
                  context,
                  authors[rowIndex].id ?? '',
                  authors[rowIndex].fullName,
                ),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete01,
                  color: Colors.red,
                ),
              ),
            ],
          );
        });
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
    _authors = authors
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'name',
                value: e.fullName,
              ),
              DataGridCell<String>(
                columnName: 'bio',
                value: e.description,
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
