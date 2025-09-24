import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_tag_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class AddEditTagBinding {
  static void init(TagModel? tag) {
    Get.lazyPut(
      () => AddEditTagController(
        tagsDatasource: Get.find<TagsDatasource>(),
        userController: Get.find<UserController>(),
        tagModel: tag,
      ),
    );
  }
}
