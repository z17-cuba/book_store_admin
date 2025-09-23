import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_publisher_controller.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AddPublisherDialog extends GetView<AddPublisherController> {
  const AddPublisherDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'app.addPublisher'.tr,
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
                // Name
                CustomTextFormField(
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.publisherName'.tr,
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
                // Email
                CustomTextFormField(
                  controller: controller.emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'app.email'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    color: Theme.of(context).highlightColor,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                  validator: (value) => value != null && value.isNotEmpty
                      ? Validator.email(value, 'app.invalidEmail'.tr)
                      : null,
                ),
                20.verticalSpace,
                // Phone
                CustomTextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.phone'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCall,
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
                20.verticalSpace,
                // Address
                CustomTextFormField(
                  controller: controller.addressController,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.done,
                  labelText: 'app.address'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedLocation01,
                    color: Theme.of(context).highlightColor,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
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
          onPressed: () => controller.createPublisher(context),
          expand: false,
          title: 'app.addPublisher'.tr,
          isFilled: true,
          color: Theme.of(context).highlightColor,
          textColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }
}
