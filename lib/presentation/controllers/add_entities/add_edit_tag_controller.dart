import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditTagController extends GetxController {
  AddEditTagController({
    required this.tagsDatasource,
    required this.userController,
    this.tagModel,
  });

  final TagsDatasource tagsDatasource;
  final UserController userController;
  TagModel? tagModel;

  // Form controllers
  final TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    if (tagModel != null) {
      nameController.text = tagModel?.name ?? '';
      update();
    }
  }

  Future<void> createEditTag(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);
        bool success = false;

        if (tagModel != null) {
          success = await tagsDatasource.updateTag(
            tagId: tagModel?.objectId ?? '',
            newName: nameController.text.trim(),
          );
        } else {
          success = await tagsDatasource.createTag(
            libraryId: userController.library?.objectId ?? '',
            name: nameController.text.trim(),
          );
        }

        if (success && context.mounted) {
          LoadingOverlay.hide(context: context);
          Navigator.of(context).pop(); // Close the dialog
          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: tagModel != null
                  ? 'app.editedTagSuccessfully'.tr
                  : 'app.createdTagSuccessfully'.tr,
            ),
          );
        }
      }
    } finally {
      if (context.mounted && LoadingOverlay.isShowing(context: context)) {
        LoadingOverlay.hide(context: context);
      }
    }
  }
}
