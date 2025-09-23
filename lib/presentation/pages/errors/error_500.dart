import 'package:book_store_admin/presentation/app/constants/assets.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Error500 extends StatelessWidget {
  const Error500({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 650;

    return SelectionArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isDesktop
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: errorWidgetsFor500,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: errorWidgetsFor500,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> errorWidgetsFor500 = [
  SizedBox(
    height: 500,
    width: 600,
    child: Image.asset(
      Assets.assetsImages404Error,
      fit: BoxFit.cover,
    ),
  ),
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "500!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 80,
        ),
      ),
      Text(
        'app.internalError'.tr,
        style: textStyleBodyBold,
      ),
      10.verticalSpace,
      Text('app.infoError500'.tr),
      10.verticalSpace,
      PrimaryButton(
        isFilled: true,
        title: 'app.backToDashboard'.tr,
        onPressed: () => NavigatorHelper.toNamed(
          Routes.home,
        ),
      )
    ],
  ),
];
