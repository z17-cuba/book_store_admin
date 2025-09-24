import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/books_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class BooksBinding {
  static void init() {
    Get.put(
      BooksController(
        bookRepository: Get.find<BookRepository>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
