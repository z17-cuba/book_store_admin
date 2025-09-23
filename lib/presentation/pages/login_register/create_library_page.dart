import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/login_register/create_library_controller.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateLibraryPage extends GetView<CreateLibraryController> {
  const CreateLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 650;

    return Scaffold(
      body: SingleChildScrollView(
        padding: isDesktop
            ? EdgeInsets.symmetric(horizontal: 0.25.sw)
            : const EdgeInsets.symmetric(
                horizontal: pagePaddingHorizontal,
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            0.03.sh.verticalSpace,
            Text(
              'app.createLibrary'.tr,
              style: textStyleGodzilla.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).highlightColor,
              ),
              textAlign: TextAlign.center,
            ),
            0.01.sh.verticalSpace,
            Text(
              'app.requiredFields'.tr,
              style: textStyleButtonBold.copyWith(
                color: Theme.of(context).highlightColor,
              ),
              textAlign: TextAlign.center,
            ),
            0.05.sh.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: pagePaddingHorizontal,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: controller.myFormCreateLibraryKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        0.025.sh.verticalSpace,
                        Text('app.contactInfo'.tr),
                        const Divider(),
                        0.025.sh.verticalSpace,
                        //Email
                        CustomTextFormField(
                          controller: controller.emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'app.email'.tr,
                          prefixIcon: HugeIcon(
                            icon: HugeIcons.strokeRoundedMail01,
                            color: Theme.of(context).highlightColor,
                          ),
                          suffixIcon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAsterisk02,
                            color: AppColors.redError,
                          ),
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) => Validator.email(
                            value,
                            'app.invalidEmail'.tr,
                          ),
                        ),
                        0.025.sh.verticalSpace,
                        //Name
                        CustomTextFormField(
                          controller: controller.nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          labelText: 'app.libraryName'.tr,
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
                        0.025.sh.verticalSpace,
                        //Phone
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
                        0.025.sh.verticalSpace,
                        //WebsiteUrl
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
                          validator: (value) =>
                              value != null && value.isNotEmpty
                                  ? Validator.url(
                                      value,
                                      'app.notValidUrl'.tr,
                                    )
                                  : null,
                        ),

                        0.025.sh.verticalSpace,
                        Text('app.address'.tr),
                        const Divider(),
                        0.025.sh.verticalSpace,
                        //Address
                        CustomTextFormField(
                          controller: controller.addressController,
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          labelText: 'app.address'.tr,
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) => Validator.notEmpty(
                            value,
                            'app.fieldIsEmpty'.tr,
                          ),
                          suffixIcon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAsterisk02,
                            color: AppColors.redError,
                          ),
                        ),
                        0.025.sh.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //State
                            Expanded(
                              child: CustomTextFormField(
                                controller: controller.stateController,
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.next,
                                labelText: 'app.state'.tr,
                                labelTextColor:
                                    Theme.of(context).highlightColor,
                                suffixIcon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAsterisk02,
                                  color: AppColors.redError,
                                ),
                                validator: (value) => Validator.notEmpty(
                                  value,
                                  'app.fieldIsEmpty'.tr,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                            //City
                            Expanded(
                              child: CustomTextFormField(
                                controller: controller.cityController,
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.next,
                                labelText: 'app.city'.tr,
                                labelTextColor:
                                    Theme.of(context).highlightColor,
                                suffixIcon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAsterisk02,
                                  color: AppColors.redError,
                                ),
                                validator: (value) => Validator.notEmpty(
                                  value,
                                  'app.fieldIsEmpty'.tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                        0.025.sh.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Country
                            Expanded(
                              child: CustomTextFormField(
                                controller: controller.countryController,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                labelText: 'app.country'.tr,
                                labelTextColor:
                                    Theme.of(context).highlightColor,
                                suffixIcon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAsterisk02,
                                  color: AppColors.redError,
                                ),
                                validator: (value) => Validator.notEmpty(
                                  value,
                                  'app.fieldIsEmpty'.tr,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                            //ZipCode
                            Expanded(
                              child: CustomTextFormField(
                                controller: controller.zipCodeController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                labelText: 'app.zipCode'.tr,
                                labelTextColor:
                                    Theme.of(context).highlightColor,
                                suffixIcon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedAsterisk02,
                                  color: AppColors.redError,
                                ),
                                validator: (value) => Validator.notEmpty(
                                  value,
                                  'app.fieldIsEmpty'.tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  0.1.sh.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: pagePaddingHorizontal,
                    ),
                    child: PrimaryButton(
                      color: Theme.of(context).highlightColor,
                      textColor: Theme.of(context).canvasColor,
                      title: 'app.createLibrary'.tr,
                      isFilled: true,
                      expand: true,
                      onPressed: () async =>
                          await controller.createLibrary(context),
                    ),
                  ),
                  0.1.sh.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
