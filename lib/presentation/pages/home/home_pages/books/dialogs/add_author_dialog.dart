import 'dart:typed_data';

import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_author_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/widgets/upload_image_card.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AddAuthorDialog extends GetView<AddAuthorController> {
  const AddAuthorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'app.addAuthor'.tr,
        style: textStyleAppBar,
      ),
      content: SizedBox(
        width: 0.4.sw,
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                0.01.sh.verticalSpace,
                Text(
                  'app.requiredFields'.tr,
                  style: textStyleButtonBold.copyWith(
                    color: Theme.of(context).highlightColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                0.05.sh.verticalSpace,
                // Photo
                Obx(
                  () => CircleImageCard(
                    imageBytes: controller.photoBytes?.value ?? Uint8List(0),
                    onSelectNewFile: () async => await controller.selectFile(),
                  ),
                ),
                20.verticalSpace,
                // First Name
                CustomTextFormField(
                  controller: controller.firstNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.firstName'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedIdentityCard,
                    color: Theme.of(context).highlightColor,
                  ),
                  suffixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedAsterisk02,
                    color: AppColors.redError,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                20.verticalSpace,
                // Last Name
                CustomTextFormField(
                  controller: controller.lastNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'app.lastName'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    color: Theme.of(context).highlightColor,
                  ),
                  suffixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedAsterisk02,
                    color: AppColors.redError,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                20.verticalSpace,
                // Bio
                CustomTextFormField(
                  controller: controller.bioController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.bio'.tr,
                  maxLines: 5,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedTextAlignCenter,
                    color: Theme.of(context).highlightColor,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                ),
                20.verticalSpace,
                // WebsiteUrl
                CustomTextFormField(
                  controller: controller.websiteUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.websiteUrl'.tr,
                  labelTextColor: Theme.of(context).highlightColor,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedLink01,
                    color: Theme.of(context).highlightColor,
                  ),
                  validator: (value) => value != null && value.isNotEmpty
                      ? Validator.url(value, 'app.notValidUrl'.tr)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('app.cancel'.tr),
        ),
        PrimaryButton(
          onPressed: () => controller.createAuthor(context),
          expand: false,
          title: 'app.addAuthor'.tr,
          isFilled: true,
          color: Theme.of(context).highlightColor,
          textColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }
}
