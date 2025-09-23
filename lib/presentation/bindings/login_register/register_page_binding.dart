import 'package:book_store_admin/presentation/controllers/login_register/register_controller.dart';
import 'package:get/get.dart';

class RegisterPageBinding {
  static void init() {
    Get.lazyPut(
      () => RegisterController(),
    );
  }
}
