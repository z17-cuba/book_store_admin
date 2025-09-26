import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_author_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class AddEditAuthorBinding {
  static void init(AuthorDomain? author) {
    Get.lazyPut(
      () => AddEditAuthorController(
        authorRepository: Get.find<AuthorRepository>(),
        userController: Get.find<UserController>(),
        authorDomain: author,
      ),
    );
  }
}
