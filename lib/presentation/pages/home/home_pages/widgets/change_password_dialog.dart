import 'package:book_store_admin/presentation/controllers/login_register/create_or_change_password_controller.dart';
import 'package:book_store_admin/presentation/pages/login_register/create_or_change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordDialog extends GetView<CreateOrChangePasswordController> {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('app.changePassword'.tr),
      content: SizedBox(
        width: 0.4.sw,
        child: ChangePasswordBaseWidget(
          controller: controller,
        ),
      ),
    );
  }
}
