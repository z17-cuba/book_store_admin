import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/login_register/create_or_change_password_controller.dart';
import 'package:book_store_admin/presentation/pages/login_register/widgets/password_visibility.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateOrChangePasswordPage
    extends GetView<CreateOrChangePasswordController> {
  const CreateOrChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangePasswordBaseWidget(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordBaseWidget extends StatelessWidget {
  const ChangePasswordBaseWidget({
    super.key,
    required this.controller,
  });

  final CreateOrChangePasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: controller.origin == 'user-page'
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(
              horizontal: pagePaddingHorizontal,
            ),
      child: Center(
        child: SizedBox(
          width: 400,
          child: Obx(
            () => Form(
              key: controller.formCreatePasswordKey,
              child: Column(
                mainAxisSize: controller.origin == 'user-page'
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: [
                  controller.origin == 'user-page'
                      ? Column(
                          children: [
                            Text(
                              'app.authInputOldAndNewPassword'.tr,
                              style: textStyleGodzilla.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: xs),
                            CustomTextFormField(
                              controller: controller.oldPassword,
                              keyboardType: TextInputType.visiblePassword,
                              focusNode: controller.focusNodeOldPassword,
                              error: controller.fieldErrors['old_password'] !=
                                      null
                                  ? Text(
                                      controller.fieldErrors['old_password']!)
                                  : null,
                              validator: (value) =>
                                  controller.origin != 'register'
                                      ? Validator.validatePassword(
                                          value,
                                          'app.fieldIsEmpty'.tr,
                                          'app.passwordRegexValidation'.tr,
                                        )
                                      : null,
                              obscureText:
                                  !controller.isOldPasswordVisible.value,
                              suffixIcon: Obx(
                                () => PasswordVisibility(
                                  color: AppColors.grey,
                                  isVisible:
                                      controller.isOldPasswordVisible.value,
                                  onPressed: () =>
                                      controller.changeOldPasswordVisibility(),
                                ),
                              ),
                              hintText: 'app.currentPassword'.tr,
                            ),
                          ],
                        )
                      : 0.05.sh.verticalSpace,
                  Column(
                    children: [
                      controller.origin == 'register'
                          ? Text(
                              'app.authInputNewPassword'.tr,
                              style: textStyleGodzilla.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor,
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: xs),
                      CustomTextFormField(
                        controller: controller.password,
                        keyboardType: TextInputType.visiblePassword,
                        focusNode: controller.focusNodePassword,
                        validator: (value) => Validator.validatePassword(
                          value,
                          'app.fieldIsEmpty'.tr,
                          'app.passwordRegexValidation'.tr,
                        ),
                        error: controller.fieldErrors['new_password'] != null
                            ? Text(controller.fieldErrors['new_password']!)
                            : null,
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: Obx(
                          () => PasswordVisibility(
                            color: AppColors.grey,
                            isVisible: controller.isPasswordVisible.value,
                            onPressed: () =>
                                controller.changePasswordVisibility(),
                          ),
                        ),
                        hintText: controller.origin == 'register'
                            ? 'app.password'.tr
                            : 'app.newPassword'.tr,
                      ),
                      const SizedBox(height: xs),
                      CustomTextFormField(
                        controller: controller.passwordConfirm,
                        keyboardType: TextInputType.visiblePassword,
                        focusNode: controller.focusNodePasswordConfirm,
                        validator: (value) => Validator.validateConfirmPassword(
                          value: value,
                          emptyString: 'app.fieldIsEmpty'.tr,
                          password: controller.password.text,
                          messageInvalidPassword:
                              'app.passwordsDoesNotMatch'.tr,
                        ),
                        obscureText: !controller.isPasswordConfirmVisible.value,
                        onSubmitted: (p0) => controller.onPressedSubmitPassword(
                          context,
                        ),
                        suffixIcon: Obx(
                          () => PasswordVisibility(
                            color: AppColors.grey,
                            isVisible:
                                controller.isPasswordConfirmVisible.value,
                            onPressed: () =>
                                controller.changePasswordConfirmVisibility(),
                          ),
                        ),
                        hintText: 'app.authConfirmPassword'.tr,
                      ),
                      controller.origin == 'user-page'
                          ? 0.05.sh.verticalSpace
                          : 0.25.sh.verticalSpace,
                      PrimaryButton(
                        isFilled: true,
                        color: Theme.of(context).highlightColor,
                        textColor: Theme.of(context).canvasColor,
                        title: 'app.accept'.tr,
                        onPressed: () =>
                            controller.onPressedSubmitPassword(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
