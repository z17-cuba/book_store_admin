import 'dart:typed_data';

import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEditAuthorController extends GetxController {
  AddEditAuthorController({
    required this.authorRepository,
    required this.userController,
    this.authorDomain,
  });

  final AuthorRepository authorRepository;
  final UserController userController;
  AuthorDomain? authorDomain;

  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  Rx<Uint8List>? photoBytes = Rx(Uint8List(0));

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    if (authorDomain != null) {
      firstNameController.text = authorDomain?.firstName ?? '';
      lastNameController.text = authorDomain?.lastName ?? '';
      bioController.text = authorDomain?.description ?? '';
      websiteUrlController.text = authorDomain?.websiteUrl ?? '';

      update();
    }
  }

  Future<void> selectFile() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photoBytes?.value = await pickedFile.readAsBytes();
      update();
    }
  }

  Future<void> createEditAuthor(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);
        bool success = false;

        if (authorDomain != null) {
          success = await authorRepository.createAuthor(
            authorDomain: AuthorDomain(
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              description: bioController.text.trim(),
              websiteUrl: websiteUrlController.text.trim(),
              nationality: nationalityController.text.trim(),
              // TODO birthDate
            ),
            photoBytes: photoBytes?.value,
            libraryId: userController.library?.objectId ?? '',
          );
        } else {
          success = await authorRepository.createAuthor(
            authorDomain: AuthorDomain(
              id: authorDomain?.id,
              photoUrl: authorDomain?.photoUrl,
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              description: bioController.text.trim(),
              websiteUrl: websiteUrlController.text.trim(),
              nationality: nationalityController.text.trim(),
              // TODO birthDate
            ),
            photoBytes: photoBytes?.value,
            libraryId: userController.library?.objectId ?? '',
          );
        }

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
