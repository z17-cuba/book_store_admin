import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/controllers/language/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChangeLanguage extends GetView<LanguageController> {
  const ChangeLanguage({
    super.key,
    this.offset,
    s,
  });

  final Offset? offset;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: 'app.changeLanguage'.tr,
        child: DropdownButton<String>(
          value: controller.currentLanguage,
          onChanged: (selectedLocale) {
            if (selectedLocale != null) {
              controller.updateLanguage(
                locale: selectedLocale,
                country: supportedLocales[selectedLocale]!,
              );
            }
          },
          items: languages(supportedLocales, controller),
        ),
      );
}

List<DropdownMenuItem<String>> languages(
  Map<String, String> supportedLocales,
  LanguageController controller,
) {
  return supportedLocales.entries.map((entry) {
    return DropdownMenuItem<String>(
      value: entry.key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            controller.getLanguageFlag(entry.value),
            height: iconSize,
          ),
          8.horizontalSpace,
          Text('app.${entry.key}'.tr),
        ],
      ),
    );
  }).toList();
}
