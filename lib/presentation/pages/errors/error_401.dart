import 'package:book_store_admin/presentation/app/constants/assets.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Error401 extends StatelessWidget {
  const Error401({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 650;

    return SelectionArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(
            pagePaddingHorizontal,
          ),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Image.asset(
                        Assets.assetsImagesUnauthorizedAccess,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: error401DescrAndButton(),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _errorWidgets(),
                ),
        ),
      ),
    );
  }
}

List<Widget> _errorWidgets() {
  return [
    SizedBox(
      height: 0.3.sh,
      width: 0.3.sh,
      child: Image.asset(
        Assets.assetsImagesUnauthorizedAccess,
        fit: BoxFit.cover,
      ),
    ),
    error401DescrAndButton(),
  ];
}

Widget error401DescrAndButton() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "401!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 80,
          ),
        ),
        Text(
          'app.error401Authentication'.tr,
          style: textStyleBodyBold,
        ),
        10.verticalSpace,
        Text('app.infoError401'.tr),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.1.sw,
          ),
          child: PrimaryButton(
            isFilled: true,
            title: 'app.signIn'.tr,
            onPressed: () async {
              final UserController userController = Get.find<UserController>();
              await userController.onSignOut();
            },
          ),
        )
      ],
    );
