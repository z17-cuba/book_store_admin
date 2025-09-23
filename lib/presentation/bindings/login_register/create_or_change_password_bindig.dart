import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/data/datasources/user_datasource.dart';
import 'package:book_store_admin/presentation/controllers/login_register/create_or_change_password_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CreateOrChangePasswordBinding {
  static void init({
    GoRouterState? state,
    ParseUser? user,
    String? origin,
  }) {
    Get.lazyPut(
      () => CreateOrChangePasswordController(
        dataUser: user ?? state?.extra as ParseUser?,
        origin: origin ?? state?.uri.queryParameters['origin'],
        accountDatasource: Get.find<AccountDatasource>(),
        userDatasource: Get.find<UserDatasource>(),
        credentialStorageDatasource: Get.find<CredentialStorageDatasource>(),
        localStorageService: Get.find<LocalStorageService>(),
      ),
    );
  }
}
