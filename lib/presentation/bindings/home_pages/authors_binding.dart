import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/authors_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class AuthorsBinding {
  static void init() {
    Get.put(
      AuthorsController(
        authorRepository: Get.find<AuthorRepository>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
