import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/edit_user_and_library_controller.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditUserAndLibraryDialog extends GetView<EditUserAndLibraryController> {
  const EditUserAndLibraryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('app.singleProfileDetails'.tr),
      content: SizedBox(
        width: 0.4.sw,
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                0.025.sh.verticalSpace,
                Text(
                  'app.singleProfileDetails'.tr,
                  style: textStyleAppBar,
                ),
                const Divider(),
                0.025.sh.verticalSpace,
                // User Email
                CustomTextFormField(
                  controller: controller.userEmailController,
                  labelText: 'app.yourEmail'.tr,
                  validator: (value) => Validator.email(
                    value,
                    'app.invalidEmail'.tr,
                  ),
                ),

                0.025.sh.verticalSpace,
                Text(
                  'app.libraryDetails'.tr,
                  style: textStyleAppBar,
                ),
                const Divider(),
                0.025.sh.verticalSpace,
                // Library Name
                CustomTextFormField(
                  controller: controller.libraryNameController,
                  labelText: 'app.libraryName'.tr,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                16.verticalSpace,
                // Library Email
                CustomTextFormField(
                  controller: controller.libraryEmailController,
                  labelText: 'app.email'.tr,
                  validator: (value) => Validator.email(
                    value,
                    'app.invalidEmail'.tr,
                  ),
                ),
                16.verticalSpace,
                // Phone
                CustomTextFormField(
                  controller: controller.phoneController,
                  labelText: 'app.phone'.tr,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                16.verticalSpace,
                // Website
                CustomTextFormField(
                  controller: controller.websiteUrlController,
                  labelText: 'app.websiteUrl'.tr,
                  validator: (value) => value != null && value.isNotEmpty
                      ? Validator.url(
                          value,
                          'app.notValidUrl'.tr,
                        )
                      : null,
                ),
                32.verticalSpace,
                Text('app.address'.tr, style: textStyleTitle),
                20.verticalSpace,
                // Address
                CustomTextFormField(
                  controller: controller.addressController,
                  labelText: 'app.address'.tr,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                16.verticalSpace,
                // State - City
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.stateController,
                        labelText: 'app.state'.tr,
                        validator: (value) => Validator.notEmpty(
                          value,
                          'app.fieldIsEmpty'.tr,
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.cityController,
                        labelText: 'app.city'.tr,
                        validator: (value) => Validator.notEmpty(
                          value,
                          'app.fieldIsEmpty'.tr,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                // Country & Zip Code
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.countryController,
                        labelText: 'app.country'.tr,
                        validator: (value) =>
                            Validator.notEmpty(value, 'app.fieldIsEmpty'.tr),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.zipCodeController,
                        labelText: 'app.zipCode'.tr,
                        validator: (value) =>
                            Validator.notEmpty(value, 'app.fieldIsEmpty'.tr),
                      ),
                    ),
                  ],
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
          onPressed: () => controller.saveChanges(context),
          title: 'app.save'.tr,
          expand: false,
          isFilled: true,
          color: Theme.of(context).highlightColor,
          textColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }
}
