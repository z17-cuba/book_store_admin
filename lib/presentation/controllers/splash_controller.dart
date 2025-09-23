import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/data/models/local/credential.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SplashController({
    required this.logger,
    required this.localStorageService,
    required this.credentialStorageDatasource,
    required this.userController,
  });

  //#region Variables

  //#region UserCase

  late AnimationController animationController;
  final Logger logger;
  final CredentialStorageDatasource credentialStorageDatasource;
  final LocalStorageService localStorageService;
  final UserController userController;
  final RxBool isLoading = false.obs;

  //#endregion

  //#endregion

  //#region Init & Close

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(vsync: this);
  }

  @override
  void onReady() async {
    super.onReady();
    await _onReady();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }

  //#endregion

  //#region Functions

  Future<void> _onReady() async {
    // Full Credentials are only stored on suscessful login
    final Credential? credential =
        await credentialStorageDatasource.getCredential();
    final bool isAuthenticated = credential != null;

    if (isAuthenticated) {
      final dynamic userProfile = await ParseUser.currentUser();

      if (userProfile != null && userProfile is ParseUser) {
        await userController.setUserProfile(userProfile, null);

        // There is no library associated with the user
        if (userController.library == null) {
          await NavigatorHelper.toNamed(Routes.createLibrary);
        }
        await NavigatorHelper.toNamed(Routes.dashboard);
      } else {
        await NavigatorHelper.toNamed(Routes.signIn);
      }
    } else {
      await NavigatorHelper.toNamed(Routes.signIn);
    }
  }

  //#endregion
}
