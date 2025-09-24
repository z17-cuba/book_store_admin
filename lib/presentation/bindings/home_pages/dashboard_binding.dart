import 'package:book_store_admin/data/datasources/books_datasource.dart';
import 'package:book_store_admin/domain/repositories/library_repository.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/dashboard_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';

class DashboardBinding {
  static void init() {
    Get.put(
      DashboardController(
        booksDatasource: Get.find<BooksDatasource>(),
        libraryRepository: Get.find<LibraryRepository>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
