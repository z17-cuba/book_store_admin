import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/books_controller.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesBooksScrollWidget extends GetView<BooksController> {
  const CategoriesBooksScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.12.sh,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3 + controller.categories.length,
          separatorBuilder: (context, index) => 10.horizontalSpace,
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? separatedPadding * 2 : 0,
              right: index == controller.categories.length + 2
                  ? separatedPadding * 2
                  : separatedPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: index == controller.pickedCategory.value
                          ? const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: PrimaryButton(
                      isFilled: controller.pickedCategory.value == index,
                      expand: false,
                      textColor: controller.pickedCategory.value == index
                          ? AppColors.secondaryColor
                          : AppColors.primaryColor,
                      onPressed: () => controller.pickCategory(index),
                      title: index == 0
                          ? 'app.allM'.tr
                          : index == 1
                              ? 'app.ebooks'.tr
                              : index == 2
                                  ? 'app.audiobooks'.tr
                                  : 'app.${controller.categories[index - 3].name}'
                                      .tr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
