import 'dart:async';

import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/data/models/library_model.dart';
import 'package:book_store_admin/presentation/bindings/login_register/create_or_change_password_bindig.dart';
import 'package:book_store_admin/presentation/controllers/login_register/create_or_change_password_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/widgets/change_password_dialog.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/bindings/edit_user_and_library_binding.dart';
import 'package:book_store_admin/presentation/controllers/edit_user_and_library_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/widgets/edit_user_and_library_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserController extends GetxController {
  UserController({
    required this.localStorageService,
    required this.accountDatasource,
    required this.credentialStorageDatasource,
    required this.libraryDatasource,
  });

  final LocalStorageService localStorageService;
  final AccountDatasource accountDatasource;
  final CredentialStorageDatasource credentialStorageDatasource;
  final LibraryDatasource libraryDatasource;

  ParseUser? userProfile;
  LibraryModel? library;

  // Completer to signal when the initial authentication check is done.
  final Completer<void> _authCompleter = Completer<void>();
  bool isAuthCheckComplete = false;

  bool get isLoggedIn => userProfile != null;
  Future<void> get authCheckFinished => _authCompleter.future;

  @override
  void onInit() {
    super.onInit();
    setUserProfile(null, null);
  }

  Future<void> setUserProfile(
    ParseUser? newUserProfile,
    String? newEmail,
  ) async {
    if (newUserProfile != null) {
      userProfile = newUserProfile;
    } else {
      ParseUser? parseUser;
      if (newEmail != null) {
        final userPass = await credentialStorageDatasource.getPassword();
        final username = await credentialStorageDatasource.getUsername();
        parseUser = ParseUser(username, userPass, newEmail);
      }
      userProfile = parseUser ??
          await ParseUser.currentUser(
            customUserObject: parseUser,
          );
    }

    final bool isAdmin = userProfile?.get(
          'isAdmin',
          defaultValue: false,
        ) ??
        false;
    if (isAdmin) {
      library = await libraryDatasource.getibrary(
          userId: userProfile?.objectId ?? '');
    }

    // Signal that the auth check is complete.
    if (!_authCompleter.isCompleted) {
      isAuthCheckComplete = true;
      _authCompleter.complete();
    }

    update();
  }

  Future<void> goToLoggedUserDetails(BuildContext context) async {
    EditUserAndLibraryBinding.init();

    await showDialog(
      context: context,
      builder: (context) => const EditUserAndLibraryDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<EditUserAndLibraryController>();
  }

  Future<void> openChangePasswordModal(BuildContext context) async {
    CreateOrChangePasswordBinding.init(
      user: userProfile,
      origin: 'user-page',
    );

    await showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );

    // Clean up controller after dialog is closed
    Get.delete<CreateOrChangePasswordController>();
  }

  Future<void> onSignOut({bool dontNavigate = false}) async {
    userProfile = null;
    await Future.wait(
      [
        localStorageService.clearTokenData(),
        credentialStorageDatasource.clearCredential(),
        accountDatasource.logout(),
      ],
    );
    if (!dontNavigate) {
      await NavigatorHelper.offAllNamed(Routes.signIn);
    }
  }
}
