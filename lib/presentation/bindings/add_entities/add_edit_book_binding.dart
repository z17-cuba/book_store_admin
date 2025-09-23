import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/domain/repositories/categories_repository.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_book_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddEditBookBinding {
  static void init(GoRouterState state) {
    //extra para no tener que hacer la peticion si ya viene
    BookDomain? extra = state.extra as BookDomain?;
    String? bookId = state.pathParameters['bookId'];

    Get.lazyPut(
      () => AddEditBookController(
        book: extra,
        bookId: bookId,
        authorRepository: Get.find<AuthorRepository>(),
        categoriesRepository: Get.find<CategoriesRepository>(),
        publisherDatasource: Get.find<PublisherDatasource>(),
        bookRepository: Get.find<BookRepository>(),
        userController: Get.find<UserController>(),
      ),
    );
  }
}
