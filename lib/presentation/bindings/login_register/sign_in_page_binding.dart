import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/presentation/controllers/login_register/sign_in_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class SignInPageBinding {
  static void init() {
    Get.lazyPut(
      () => SignInController(
        credentialStorageDatasource: Get.find<CredentialStorageDatasource>(),
        accountDatasource: Get.find<AccountDatasource>(),
        localStorageService: Get.find<LocalStorageService>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
