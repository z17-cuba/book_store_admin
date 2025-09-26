import 'package:book_store_admin/presentation/bindings/home_pages/authors_binding.dart';
import 'package:book_store_admin/presentation/bindings/home_pages/books_binding.dart';
import 'package:book_store_admin/presentation/bindings/home_pages/dashboard_binding.dart';
import 'package:book_store_admin/presentation/bindings/home_pages/tags_binding.dart';
import 'package:book_store_admin/presentation/pages/home/authors_page.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/books_page.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/dashboard/dashboard_page.dart';
import 'package:book_store_admin/presentation/routes/dashboard_item.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/pages/home/tags_page.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class DashboardItemsConfigAdmin {
  static List<DashboardItem> items = [
    DashboardItem(
      title: () => 'app.dashboard'.tr,
      icon: HugeIcons.strokeRoundedHome09,
      tag: 'dashboard',
      routeName: Routes.dashboard,
      routePath: '/${Routes.dashboard}',
      pageBuilder: (context, state) {
        DashboardBinding.init();
        return const DashboardPage();
      },
    ),
    // Books.
    DashboardItem(
      title: () => 'app.books'.tr,
      routeName: Routes.books,
      tag: 'books',
      routePath: '/${Routes.books}',
      icon: HugeIcons.strokeRoundedBooks01,
      pageBuilder: (context, state) {
        BooksBinding.init();
        return const BooksPage();
      },
    ),
    // Tags.
    DashboardItem(
      title: () => 'app.tags'.tr,
      routeName: Routes.tags,
      tag: 'tags',
      routePath: '/${Routes.tags}',
      icon: HugeIcons.strokeRoundedTag01,
      pageBuilder: (context, state) {
        TagsBinding.init();
        return const TagsPage();
      },
    ),
    // Authors.
    DashboardItem(
      title: () => 'app.authors'.tr,
      routeName: Routes.authors,
      tag: 'authors',
      routePath: '/${Routes.authors}',
      icon: HugeIcons.strokeRoundedQuillWrite01,
      pageBuilder: (context, state) {
        AuthorsBinding.init();
        return const AuthorsPage();
      },
    ),
  ];
}
