import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/data/models/library_model.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CreateLibraryController extends GetxController {
  CreateLibraryController({
    //Path params
    this.dataUser,
    // Imports
    required this.userController,
    required this.libraryDatasource,
  });

  late ParseUser? dataUser;
  final UserController userController;
  final LibraryDatasource libraryDatasource;

  //Form validators
  //Address
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  //Address -- Contact
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  // End Contact

  final RxBool isFormStateError = false.obs;

  final myFormCreateLibraryKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    emailController.text = dataUser?.emailAddress ?? '';

    super.onInit();
  }

  Future<void> createLibrary(BuildContext context) async {
    try {
      final form = myFormCreateLibraryKey.currentState;
      if (form!.validate()) {
        LoadingOverlay.show(context: context);
        isFormStateError.value = false;

        final bool response = await libraryDatasource.createLibrary(
          library: LibraryModel(
            //Address
            city: cityController.text.trim(),
            address: addressController.text.trim(),
            state: stateController.text.trim(),
            country: countryController.text.trim(),
            zipCode: zipCodeController.text.trim(),
            //Address -- Contact
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneController.text.trim(),
            websiteUrl: websiteUrlController.text.trim(),
          ),
          userId: dataUser?.objectId ?? '',
        );

        if (response) {
          await userController.setUserProfile(null, null);

          if (context.mounted) {
            LoadingOverlay.hide(context: context);

            ToastHelper.showToast(
              context: context,
              toast: ToastWithColor.success(
                message: 'app.createdLibrarySuccessfully'.tr,
                isLightBackground: false,
              ),
            );
          }

          await NavigatorHelper.offAllNamed(Routes.dashboard);
        }
      }
    } finally {
      if (context.mounted) LoadingOverlay.hide(context: context);
    }
  }
}
