import 'dart:typed_data';

import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/author_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddAuthorController extends GetxController {
  AddAuthorController({
    required this.authorDatasource,
  });

  final AuthorDatasource authorDatasource;

  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  Rx<Uint8List>? photoBytes = Rx(Uint8List(0));

  final formKey = GlobalKey<FormState>();

  Future<void> selectFile() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photoBytes?.value = await pickedFile.readAsBytes();
      update();
    }
  }

  Future<void> createAuthor(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);

        final bool success = await authorDatasource.createAuthor(
          authorModel: AuthorModel(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            bio: bioController.text.trim(),
            websiteUrl: websiteUrlController.text.trim(),
            nationality: nationalityController.text.trim(),
            // TODO birthDate
          ),
          photoBytes: photoBytes?.value,
        );

        if (success && context.mounted) {
          LoadingOverlay.hide(context: context);
          Navigator.of(context).pop(); // Close the dialog
          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: 'app.createdAuthorSuccessfully'.tr,
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
