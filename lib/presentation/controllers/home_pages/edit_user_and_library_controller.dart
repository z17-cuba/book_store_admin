import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/data/datasources/user_datasource.dart';
import 'package:book_store_admin/data/models/library_model.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserAndLibraryController extends GetxController {
  EditUserAndLibraryController({
    required this.userController,
    required this.libraryDatasource,
    required this.userDatasource,
  });

  final UserController userController;
  final LibraryDatasource libraryDatasource;
  final UserDatasource userDatasource;

  final formKey = GlobalKey<FormState>();

  // User Controllers
  late final TextEditingController userEmailController;

  // Library Controllers
  late final TextEditingController libraryNameController;
  late final TextEditingController libraryEmailController;
  late final TextEditingController phoneController;
  late final TextEditingController websiteUrlController;
  late final TextEditingController addressController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController countryController;
  late final TextEditingController zipCodeController;

  @override
  void onInit() {
    super.onInit();
    // Initialize User controllers
    userEmailController = TextEditingController(
        text: userController.userProfile?.emailAddress ?? '');

    // Initialize Library controllers
    final library = userController.library;
    libraryNameController = TextEditingController(text: library?.name ?? '');
    libraryEmailController = TextEditingController(text: library?.email ?? '');
    phoneController = TextEditingController(text: library?.phone ?? '');
    websiteUrlController =
        TextEditingController(text: library?.websiteUrl ?? '');
    addressController = TextEditingController(text: library?.address ?? '');
    cityController = TextEditingController(text: library?.city ?? '');
    stateController = TextEditingController(text: library?.state ?? '');
    countryController = TextEditingController(text: library?.country ?? '');
    zipCodeController = TextEditingController(text: library?.zipCode ?? '');
  }

  @override
  void onClose() {
    userEmailController.dispose();
    libraryNameController.dispose();
    libraryEmailController.dispose();
    phoneController.dispose();
    websiteUrlController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  Future<void> saveChanges(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      LoadingOverlay.show(context: context);
      try {
        final String userEmail = userEmailController.text.trim();

        if ((userEmail.isNotEmpty &&
            userEmail != userController.userProfile?.emailAddress)) {
          // Update User
          await userDatasource.updateUser(
            userId: userController.userProfile!.objectId!,
            email: userEmail.isNotEmpty ? userEmail : null,
          );
        }

        // Update Library
        final updatedLibrary = LibraryModel(
          objectId: userController.library!.objectId,
          name: libraryNameController.text.trim(),
          email: libraryEmailController.text.trim(),
          phone: phoneController.text.trim(),
          websiteUrl: websiteUrlController.text.trim(),
          address: addressController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          country: countryController.text.trim(),
          zipCode: zipCodeController.text.trim(),
        );

        await libraryDatasource.updateLibrary(
          library: updatedLibrary,
        );

        // Refresh user and library data
        await userController.setUserProfile(
          null,
          (userEmail.isNotEmpty &&
                  userEmail != userController.userProfile?.emailAddress)
              ? userEmail
              : null,
        );

        if (context.mounted) {
          LoadingOverlay.hide(context: context);
          Navigator.of(context).pop(); // Close the dialog

          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: 'app.settingsSaved'.tr,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          LoadingOverlay.hide(context: context);
          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.error(
              message: 'app.unknownError'.tr,
            ),
          );
        }
      }
    }
  }
}
