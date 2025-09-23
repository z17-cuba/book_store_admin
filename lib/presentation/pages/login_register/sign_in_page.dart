import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/login_register/sign_in_controller.dart';
import 'package:book_store_admin/presentation/pages/login_register/widgets/password_visibility.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/list_text_with_navigation.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

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
              'app.signIn'.tr,
              style: textStyleGodzilla.copyWith(
                fontWeight: FontWeight.bold,
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
                    key: controller.myFormSignInKey,
                    child: Column(
                      children: [
                        //Email
                        CustomTextFormField(
                          controller: controller.usernameOrEmailController,
                          textInputAction: TextInputAction.next,
                          focusNode: controller.focusNodeUsernameOrEmail,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'app.yourUsername'.tr,
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) => Validator.notEmpty(
                            value,
                            'app.fieldIsEmpty'.tr,
                          ),
                        ),
                        0.015.sh.verticalSpace,
                        //Password
                        Obx(
                          () => CustomTextFormField(
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            labelText: 'app.password'.tr,
                            focusNode: controller.focusNodePassword,
                            labelTextColor: Theme.of(context).highlightColor,
                            obscureText: controller.obscurePass.value,
                            onSubmitted: (_) async =>
                                await controller.signIn(context),
                            validator: (value) => Validator.validatePassword(
                              value,
                              'app.fieldIsEmpty'.tr,
                              'app.passwordRegexValidation'.tr,
                            ),
                            suffixIcon: Obx(
                              () => PasswordVisibility(
                                color: AppColors.grey,
                                isVisible: controller.obscurePass.value,
                                onPressed: () => controller.changeObscurePass(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*    12.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: ListTextWithNavigation(
                      textOne: '',
                      textAlign: TextAlign.center,
                      textStyleTextOne: textStyleButton.copyWith(
                        color: Theme.of(context).highlightColor,
                      ),
                      texts: [
                        TextWithTap(
                          text: 'app.authForgotPassword'.tr,
                          textStyle: textStyleButtonBold,
                          onTap: () => controller.goToForgotPassword(),
                        ),
                      ],
                    ),
                  ), */
                  0.28.sh.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: pagePaddingHorizontal,
                    ),
                    child: PrimaryButton(
                      color: Theme.of(context).highlightColor,
                      textColor: Theme.of(context).canvasColor,
                      title: 'app.signIn'.tr,
                      isFilled: true,
                      expand: true,
                      onPressed: () async => await controller.signIn(context),
                    ),
                  ),
                ],
              ),
            ),
            15.verticalSpace,
            ListTextWithNavigation(
              textOne: 'app.dontHaveAnAccount'.tr,
              textAlign: TextAlign.center,
              textStyleTextOne: textStyleButton.copyWith(
                color: Theme.of(context).highlightColor,
              ),
              texts: [
                TextWithTap(
                  text: 'app.createAnAccount'.tr,
                  textStyle: textStyleButtonBold,
                  onTap: controller.goToRegister,
                ),
              ],
            ),
            15.verticalSpace,
          ],
        ),
      ),
    );
  }
}
