import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/data/datasources/user_datasource.dart';
import 'package:book_store_admin/presentation/controllers/edit_user_and_library_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class EditUserAndLibraryBinding {
  static void init() {
    Get.lazyPut<EditUserAndLibraryController>(
      () => EditUserAndLibraryController(
          userController: Get.find<UserController>(),
          libraryDatasource: Get.find<LibraryDatasource>(),
          userDatasource: Get.find<UserDatasource>()),
    );
  }
}
