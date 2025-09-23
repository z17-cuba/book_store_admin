import 'package:book_store_admin/presentation/bindings/books_binding.dart';
import 'package:book_store_admin/presentation/bindings/dashboard_binding.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/books_page.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/dashboard/dashboard_page.dart';
import 'package:book_store_admin/presentation/routes/dashboard_item.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
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
  ];
}
