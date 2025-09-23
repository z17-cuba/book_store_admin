import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/presentation/controllers/login_register/create_library_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CreateLibraryBinding {
  static void init(GoRouterState state) {
    //extra para no tener que hacer la peticion si ya viene
    ParseUser? extra = state.extra as ParseUser?;

    Get.lazyPut(
      () => CreateLibraryController(
        dataUser: extra ?? Get.find<UserController>().userProfile,
        userController: Get.find<UserController>(),
        libraryDatasource: Get.find<LibraryDatasource>(),
      ),
    );
  }
}
