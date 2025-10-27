import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/login_register/register_controller.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/list_text_with_navigation.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                0.1.sh.verticalSpace,
                Text(
                  'app.createAnAccount'.tr,
                  style: textStyleGodzilla.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).highlightColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                0.05.sh.verticalSpace,
                Form(
                  key: controller.myFormRegisterKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: controller.username,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        labelText: 'app.yourUsername'.tr,
                        labelTextColor: Theme.of(context).highlightColor,
                        validator: (value) => Validator.notEmpty(
                          value,
                          'app.fieldIsEmpty'.tr,
                        ),
                      ),
                      10.verticalSpace,
                      CustomTextFormField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        labelText: 'app.yourEmail'.tr,
                        labelTextColor: Theme.of(context).highlightColor,
                        onSubmitted: (_) async =>
                            await controller.onPressedSubmit(),
                        validator: (value) => Validator.email(
                          value,
                          'app.invalidEmail'.tr,
                        ),
                      ),
                    ],
                  ),
                ),
                0.25.sh.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: pagePaddingHorizontal,
                  ),
                  child: PrimaryButton(
                    color: Theme.of(context).highlightColor,
                    textColor: Theme.of(context).canvasColor,
                    title: 'app.next'.tr,
                    isFilled: true,
                    expand: true,
                    onPressed: () async => await controller.onPressedSubmit(),
                  ),
                ),
                15.verticalSpace,
                ListTextWithNavigation(
                  textOne: 'app.alreadyHaveAccount'.tr,
                  textAlign: TextAlign.center,
                  textStyleTextOne: textStyleButton.copyWith(
                    color: Theme.of(context).highlightColor,
                  ),
                  texts: [
                    TextWithTap(
                      text: 'app.signIn'.tr,
                      textStyle: textStyleButtonBold,
                      onTap: controller.goToSignIn,
                    ),
                  ],
                ),
                15.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
