import 'package:book_store_admin/data/datasources/author_datasource.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_author_controller.dart';
import 'package:get/get.dart';

class AddAuthorBinding {
  static void init() {
    Get.lazyPut(
      () => AddAuthorController(
        authorDatasource: Get.find<AuthorDatasource>(),
      ),
    );
  }
}
