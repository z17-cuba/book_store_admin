import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RegisterController extends GetxController {
  //Form validators

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final RxBool isFormStateError = false.obs;

  final myFormRegisterKey = GlobalKey<FormState>();

  Future<void> goToSignIn() async {
    await NavigatorHelper.offAllNamed(
      Routes.signIn,
    );
  }

  Future<void> onPressedSubmit() async {
    final form = myFormRegisterKey.currentState;
    if (form!.validate()) {
      isFormStateError.value = false;

      await NavigatorHelper.toNamed(
        Routes.createPassword,
        queryParameters: {
          'origin': 'register',
        },
        extra: ParseUser(
          username.text.trim(),
          null,
          email.text.trim(),
        ),
      );
    } else {
      isFormStateError.value = true;
    }
  }
}
