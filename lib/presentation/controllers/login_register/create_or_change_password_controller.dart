import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/data/datasources/user_datasource.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CreateOrChangePasswordController extends GetxController {
  CreateOrChangePasswordController({
    //Path params
    this.dataUser,
    required this.origin,
    // Imports
    required this.credentialStorageDatasource,
    required this.userDatasource,
    required this.accountDatasource,
    required this.localStorageService,
  });

  final CredentialStorageDatasource credentialStorageDatasource;
  final UserDatasource userDatasource;
  final AccountDatasource accountDatasource;
  final LocalStorageService localStorageService;

  final formCreatePasswordKey = GlobalKey<FormState>();

  RxMap<String, String> fieldErrors = <String, String>{}.obs;

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirm = TextEditingController();

  final FocusNode focusNodeOldPassword = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodePasswordConfirm = FocusNode();

  final RxBool isOldPasswordVisible = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isPasswordConfirmVisible = false.obs;

  final RxBool isLoading = false.obs;

  late ParseUser? dataUser;
  final RxString username = ''.obs;
  final String? origin; // register / user-page
  String? email;

  @override
  void onInit() {
    email = dataUser?.emailAddress ?? '';
    super.onInit();
  }

  @override
  void onClose() {
    oldPassword.dispose();
    password.dispose();
    passwordConfirm.dispose();
    focusNodeOldPassword.dispose();
    focusNodePassword.dispose();
    focusNodePasswordConfirm.dispose();
    super.onClose();
  }

  void changeOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void changePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changePasswordConfirmVisibility() {
    isPasswordConfirmVisible.value = !isPasswordConfirmVisible.value;
  }

  Future<void> onPressedSubmitPassword(BuildContext context) async {
    try {
      final formCreateState = formCreatePasswordKey.currentState;
      if (formCreateState!.validate()) {
        fieldErrors.clear();
        //Updating dataUser
        dataUser?.password = password.text.trim();

        isLoading.value = true;
        focusNodePassword.unfocus();
        focusNodePasswordConfirm.unfocus();

        if (origin == 'register') {
          LoadingOverlay.show(context: context);
          //Api calls
          final response = await accountDatasource.signUp(
            email: dataUser?.emailAddress ?? '',
            username: dataUser?.username ?? '',
            password: dataUser?.password! ?? '',
          );

          if (response != null && response) {
            await credentialStorageDatasource.storageCredential(
              username: dataUser?.username ?? '',
              password: dataUser?.password! ?? '',
              email: dataUser?.emailAddress,
            );

            await accountDatasource.signIn(
              username: dataUser?.username ?? '',
              password: dataUser?.password! ?? '',
              email: dataUser?.emailAddress,
            );

            final ParseUser? loggedUser = await ParseUser.currentUser();

            if (loggedUser != null) {
              await userDatasource.updateUser(
                userId: loggedUser.objectId ?? '',
                setAdmin: true,
              );
            }
            if (context.mounted) {
              ToastHelper.showToast(
                context: context,
                toast: ToastWithColor.success(
                  message: 'app.createdUserSuccessfully'.tr,
                  isLightBackground: false,
                ),
              );
              LoadingOverlay.hide(context: context);
            }

            await NavigatorHelper.toNamed(
              Routes.createLibrary,
            );
          }
        } else {
          LoadingOverlay.show(context: context);
          final response = await accountDatasource.changePassword(
            oldPassword: oldPassword.text.trim(),
            newPassword: password.text.trim(),
          );

          if (response != null && response) {
            await credentialStorageDatasource.storageCredential(
              username: dataUser?.username ?? '',
              password: dataUser?.password! ?? '',
              email: dataUser?.emailAddress,
            );

            if (context.mounted) {
              LoadingOverlay.hide(context: context);
              Navigator.of(context).pop();

              ToastHelper.showToast(
                context: context,
                toast: ToastWithColor.success(
                  message: 'app.settingsSaved'.tr,
                ),
              );
            }
          }
        }
      }
    } on CustomException catch (e) {
      if (origin == 'register') {
        if (e.code == errorEmailAlreadyTaken) {
          Get.back();

          if (context.mounted) {
            ToastHelper.showToast(
              context: context,
              toast: ToastWithColor.error(
                message: 'app.emailAlreadyTaken'.tr,
                isLightBackground: false,
              ),
            );
          }
        } else if (e.code == errorEmailAlreadyTaken) {
          Get.back();

          if (context.mounted) {
            ToastHelper.showToast(
              context: context,
              toast: ToastWithColor.error(
                message: 'app.usernameAlreadyTaken'.tr,
                isLightBackground: false,
              ),
            );
          }
        }
      } else if (origin == 'user-page') {
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
      }

      return;
    } finally {
      if (context.mounted) LoadingOverlay.hide(context: context);
      isLoading.value = false;
    }
  }
}
