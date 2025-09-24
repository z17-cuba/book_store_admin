import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_tag_controller.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AddEditTagDialog extends GetView<AddEditTagController> {
  const AddEditTagDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        controller.tagsModel != null ? 'app.editTag'.tr : 'app.addTag'.tr,
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
                  labelText: 'app.name'.tr,
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
          onPressed: () => controller.createEditTag(context),
          expand: false,
          title:
              controller.tagsModel != null ? 'app.editTag'.tr : 'app.addTag'.tr,
          isFilled: true,
          color: Theme.of(context).highlightColor,
          textColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }
}
