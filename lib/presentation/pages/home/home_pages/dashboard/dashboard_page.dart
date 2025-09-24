import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: pagePaddingHorizontal,
        ),
        child: Column(
          children: [
            10.verticalSpace,
            SizedBox(
              height: 0.15.sh,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          roundCornerRadius,
                        ),
                        border: Border.all(
                          color: AppColors.grey200,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'app.books'.tr,
                            style: textStyleAppBar,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBooks01,
                                color: Theme.of(context).highlightColor,
                              ),
                              Obx(
                                () => Text(
                                  controller.booksByLibrary.value.toString(),
                                  style: textStyleAppBar,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          roundCornerRadius,
                        ),
                        border: Border.all(
                          color: AppColors.grey200,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'app.boughtBooks'.tr,
                            style: textStyleAppBar,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedMoneySavingJar,
                                color: Theme.of(context).highlightColor,
                              ),
                              Obx(
                                () => Text(
                                  controller.boughtBooksAmount.value.toString(),
                                  style: textStyleAppBar,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          roundCornerRadius,
                        ),
                        border: Border.all(
                          color: AppColors.grey200,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'app.readedBooks'.tr,
                            style: textStyleAppBar,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBookOpen01,
                                color: Theme.of(context).highlightColor,
                              ),
                              Obx(
                                () => Text(
                                  controller.readedBooksAmount.value.toString(),
                                  style: textStyleAppBar,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        roundCornerRadius,
                      ),
                      border: Border.all(
                        color: AppColors.grey200,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      separatedPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedMoneySavingJar,
                              color: Theme.of(context).highlightColor,
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                'app.mostBoughtBooks'.tr,
                                style: textStyleAppBar,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Obx(
                          () => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.mostBoughtBooks.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                controller.mostBoughtBooks.entries
                                        .elementAt(index)
                                        .key
                                        .title ??
                                    '',
                                style: textStyleAppBar,
                              ),
                              trailing: Text(
                                controller.mostBoughtBooks.entries
                                    .elementAt(index)
                                    .value
                                    .toString(),
                                style: textStyleBody,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.mostBoughtBooks.length > limitQueries
                              ? Column(
                                  children: [
                                    5.verticalSpace,
                                    TextButton(
                                      onPressed: () => controller
                                          .navigateToMoreBoughtBooks(),
                                      child: Text(
                                        'app.viewMore'.tr,
                                        style: textStyleBody.copyWith(
                                          color: AppColors.accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        roundCornerRadius,
                      ),
                      border: Border.all(
                        color: AppColors.grey200,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      separatedPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedBookOpen01,
                              color: Theme.of(context).highlightColor,
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                'app.mostReadedBooks'.tr,
                                style: textStyleAppBar,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Obx(
                          () => ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.mostReadedBooks.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                controller.mostReadedBooks.entries
                                        .elementAt(index)
                                        .key
                                        .title ??
                                    '',
                                style: textStyleAppBar,
                              ),
                              trailing: Text(
                                controller.mostReadedBooks.entries
                                    .elementAt(index)
                                    .value
                                    .toString(),
                                style: textStyleBody,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.mostReadedBooks.length > limitQueries
                              ? Column(
                                  children: [
                                    5.verticalSpace,
                                    TextButton(
                                      onPressed: () => controller
                                          .navigateToMoreReadedBooks(),
                                      child: Text(
                                        'app.viewMore'.tr,
                                        style: textStyleBody.copyWith(
                                          color: AppColors.accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
