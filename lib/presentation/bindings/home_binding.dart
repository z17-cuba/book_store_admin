import 'package:book_store_admin/presentation/controllers/home_controller.dart';
import 'package:book_store_admin/presentation/controllers/language/language_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeBinding {
  static void init() {
    ///NOTA: no se puede hacer con el lazyPut xq se destruye y se vuelve a cerrar el controller cada vez que se navega
    ///lo que hace que se ejecute el fetch mil veces, asi solo se ejecuta la primera vez, el resto por la paginacion normal
    Get.put(
      HomeController(
        userController: Get.find<UserController>(),
        languageController: Get.find<LanguageController>(),
        packageInfo: Get.find<PackageInfo>(),
      ),
    );
  }
}
