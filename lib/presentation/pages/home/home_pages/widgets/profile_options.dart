import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileOptions extends GetView<UserController> {
  // TODO: change to use enums instead of strings
  final Offset? offset;
  final Map<String, String> _items = {
    'singleProfileDetails': 'app.singleProfileDetails'.tr,
    'changePassword': 'app.changePassword'.tr,
    'logOut': 'app.logOut'.tr,
  };

  ProfileOptions({
    super.key,
    this.offset,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
        message: 'app.options'.tr,
        child: PopupMenuButton<String>(
          tooltip: '', // Tooltip is handled by the parent
          onSelected: (selectedOption) async {
            if (selectedOption == 'singleProfileDetails') {
              await controller.goToLoggedUserDetails(context);
            } else if (selectedOption == 'changePassword') {
              await controller.openChangePasswordModal(context);
            } else if (selectedOption == 'logOut') {
              await controller.onSignOut();
            }
          },
          itemBuilder: (BuildContext context) {
            return _items.entries.map((entry) {
              return PopupMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: textStyleBodyBold,
                ),
              );
            }).toList();
          },
          child: CircleAvatar(
            backgroundColor: AppColors.secondaryColor,
            child: Text(
              controller.userProfile?.emailAddress
                      ?.substring(0, 1)
                      .toUpperCase() ??
                  'A',
              style: textStyleBodyBold.copyWith(
                color: AppColors.canvasColorWhite,
              ),
            ),
          ),
        ),
      );
}
