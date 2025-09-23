import 'package:book_store_admin/presentation/controllers/language/language_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/dashboard_items_config_admin.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  HomeController({
    required this.userController,
    required this.languageController,
    required this.packageInfo,
  });

  //#region Uses Cases and Controllers

  /// Controller used to manage the user information.
  final UserController userController;

  /// Controller used to manage the aplication language.
  final LanguageController languageController;

  /// Info of the app version and build
  final PackageInfo packageInfo;

  //#endregion Uses Cases and Controllers

  //#region Variables

  int currentParentPage = 0;
  int currentChildPage = 0;

  /// True if show only the icons in the side menu.
  bool showIconsOnly = false;

  //#endregion Variables

  //#region Functions

  /// Change if show or not only the icons in the side menu.
  void changeShowIconsOnly(bool newValue) {
    showIconsOnly = newValue;
    update();
  }

  ///NOTA: Si se entra directo por url a una ruta especifica, por ejemplo /users/algo
  ///se hace bien la navegacion, PERO, no se actualiza el selected del dashboard ni el expanded del 'users'
  ///para eso hay que cambiar la manera en que funciona el 'isSelected' comparando por la url, no por el index.
  ///This is now handled by the logic in HomePage's build method.
  void updateParentSelectedIndex(int index) {
    if (currentParentPage == index) return;
    currentParentPage = index;
    update();
  }

  void updateChildSelectedIndexFromRoute(GoRouter router) {
    final String location = router.routeInformationProvider.value.uri.path;
    final parentConfig = DashboardItemsConfigAdmin.items[currentParentPage];

    final childIndex = parentConfig.pageChilds.indexWhere(
      (child) => location.startsWith(child.routePath),
    );

    if (childIndex != -1) {
      if (currentChildPage != childIndex) {
        currentChildPage = childIndex;
        update();
      }
    } else {
      // If no child route matches, reset the child index
      currentChildPage = 0;
    }
  }

  void updateChildSelectedIndex({
    required int parentIndex,
    required int index,
  }) {
    currentParentPage = parentIndex;
    currentChildPage = index;
    update();
  }

  /// The current Language of the app.
  String get getCurrentLanguage => languageController.currentLanguage;
}
