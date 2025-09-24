import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/tags_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class TagsBinding {
  static void init() {
    Get.put(
      TagsController(
          tagsDatasource: Get.find<TagsDatasource>(),
          userController: Get.find<UserController>()),
    );
  }
}
