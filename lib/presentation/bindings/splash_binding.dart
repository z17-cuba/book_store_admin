import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/presentation/controllers/splash_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashBinding {
  static void init() {
    Get.lazyPut(
      () => SplashController(
        logger: Get.find<Logger>(),
        userController: Get.find<UserController>(),
        localStorageService: Get.find<LocalStorageService>(),
        credentialStorageDatasource: Get.find<CredentialStorageDatasource>(),
      ),
    );
  }
}
