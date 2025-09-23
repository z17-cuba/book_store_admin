import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/core/regex_validations.dart';
import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  SignInController({
    required this.credentialStorageDatasource,
    required this.accountDatasource,
    required this.localStorageService,
    required this.userController,
  });

  final CredentialStorageDatasource credentialStorageDatasource;
  final AccountDatasource accountDatasource;
  final LocalStorageService localStorageService;
  final UserController userController;

  //Form validators
  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode focusNodeUsernameOrEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  final RxBool isFormStateError = false.obs;

  RxBool obscurePass = true.obs;

  final myFormSignInKey = GlobalKey<FormState>();

  void changeObscurePass() {
    obscurePass.value = !obscurePass.value;
  }

  Future<void> goToRegister() async {
    await NavigatorHelper.toNamed(Routes.register);
  }

  Future<void> goToForgotPassword() async {
    // Get.toNamed(Routes.forgotPassword);
  }

  Future<void> signIn(BuildContext context) async {
    try {
      final form = myFormSignInKey.currentState;
      if (form!.validate()) {
        LoadingOverlay.show(context: context);
        isFormStateError.value = false;
        focusNodeUsernameOrEmail.unfocus();
        focusNodePassword.unfocus();

        String safeUsernameOrEmail = usernameOrEmailController.text.trim();
        String safePassword = passwordController.text.trim();

        final bool isValidEmail =
            emailValidationRegEx.hasMatch(safeUsernameOrEmail);

        final bool? response = await accountDatasource.signIn(
          username: safeUsernameOrEmail,
          password: safePassword,
          email: isValidEmail ? safeUsernameOrEmail : null,
        );

        if (response != null && response) {
          await credentialStorageDatasource.storageCredential(
            username: safeUsernameOrEmail,
            password: safePassword,
            email: isValidEmail ? safeUsernameOrEmail : null,
          );

          if (context.mounted) LoadingOverlay.hide(context: context);

          await userController.setUserProfile(null, null);

          if (userController.library == null) {
            await NavigatorHelper.toNamed(Routes.createLibrary);
          } else {
            await NavigatorHelper.offAllNamed(Routes.dashboard);
          }
        }
      }
    } on CustomException catch (e) {
      if (e.code == errorInvalidCredentials) {
        if (context.mounted) {
          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.error(
              message: 'app.invalidCredentials'.tr,
              isLightBackground: false,
            ),
          );
        }
      }
      return;
    } finally {
      if (context.mounted) LoadingOverlay.hide(context: context);
    }
  }
}
