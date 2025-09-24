import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/bindings/add_entities/add_edit_tag_binding.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_tag_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/dialogs/add_edit_tag_dialog.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TagsController extends GetxController {
  TagsController({
    required this.tagsDatasource,
    required this.userController,
  });

  final TagsDatasource tagsDatasource;
  final UserController userController;

  // -> Tags
  final RxList<TagModel> tagsByLibrary = <TagModel>[].obs;
  final RxBool isLoadingTags = true.obs;
  final RxBool noMoreTags = false.obs;

  late TagsDataGridSource tagsDataGridSource;
  final DataGridController dataGridController = DataGridController();
  // Pagination
  int skip = 0;

  @override
  Future<void> onInit() async {
    tagsDataGridSource = TagsDataGridSource(
      tags: tagsByLibrary,
      controller: this,
    );
    await loadTagsByLibrary();
    super.onInit();
  }

  Future<void> addEditTag(
    BuildContext context,
    TagModel? tagModel,
  ) async {
    AddEditTagBinding.init(tagModel);

    await showDialog(
      context: context,
      builder: (context) => const AddEditTagDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<AddEditTagController>();
  }

  Future<void> deleteTag(
    BuildContext context,
    String tagId,
    String tagName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('app.deleteTag'.tr),
          content: Text(
            'app.deleteTagWarning'.trParams({
              'title': tagName,
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
              title: 'app.deleteTag'.tr,
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
        final success = await tagsDatasource.deleteTag(tagId: tagId);
        if (success) {
          tagsByLibrary.removeWhere((tag) => tag.objectId == tagId);
          tagsDataGridSource.updateDataGridSource();
        }
      } finally {
        if (context.mounted) {
          LoadingOverlay.hide(context: context);
        }
      }
    }
  }

  Future<void> loadTagsByLibrary({bool? shouldRefresh}) async {
    if (shouldRefresh != null && shouldRefresh) {
      skip = 0;
    }

    if (!noMoreTags.value) {
      List<TagModel> tempResult = await tagsDatasource.getAllTagsByLibrary(
        skip: skip,
        libraryId: userController.library?.objectId ?? '',
      );

      skip += limitQueries;
      noMoreTags.value = tempResult.isEmpty;

      for (TagModel tag in tempResult) {
        final bool hasTag =
            tagsByLibrary.any((t) => t.objectId == tag.objectId);
        if (!hasTag) {
          tagsByLibrary.add(tag);
        } else if (hasTag &&
            tag.name !=
                tagsByLibrary
                    .firstWhere((t) => t.objectId == tag.objectId)
                    .name) {
          final int tagIndex =
              tagsByLibrary.indexWhere((t) => t.objectId == tag.objectId);
          tagsByLibrary[tagIndex] = tag;
        }
      }
    }
    tagsDataGridSource.updateDataGridSource();
    update();
    isLoadingTags.value = false;
  }
}

class TagsDataGridSource extends DataGridSource {
  TagsDataGridSource({
    required this.tags,
    required this.controller,
  }) {
    _buildDataGridRows();
  }

  final List<TagModel> tags;
  List<DataGridRow> _books = [];

  @override
  List<DataGridRow> get rows => _books;
  final TagsController controller;

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
                tooltip: 'app.editTag'.tr,
                onPressed: () => controller.addEditTag(
                  context,
                  tags[rowIndex],
                ),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBookEdit,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              IconButton(
                tooltip: 'app.deleteTag'.tr,
                onPressed: () => controller.deleteTag(
                  context,
                  tags[rowIndex].objectId ?? '',
                  tags[rowIndex].name ?? '',
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
    _books = tags
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'name',
                value: e.name,
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
