import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/presentation/app/constants/assets.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  LanguageController({
    required this.localStorageService,
  });

  static LanguageController get to => Get.find<LanguageController>();
  final LocalStorageService localStorageService;
  final languageCode = ''.obs;
  late SharedPreferences prefs;
  final countryCode = ''.obs;

  String get currentLanguage =>
      languageCode.isNotEmpty ? languageCode.value : defaultLanguage;

  String get currentCountry =>
      countryCode.isNotEmpty ? countryCode.value : defaultCountry;

  /// Gets the associated flag to the language.
  String getLanguageFlag(String? country) {
    switch (country ?? currentCountry) {
      case 'ES':
        return Assets.assetsSvgsFlagsSpain;
      case 'US':
        return Assets.assetsSvgsFlagsUnitedStates;
      default:
        return Assets.assetsSvgsFlagsSpain;
    }
  }

  // Gets current language stored
  (RxString, RxString) get currentLanguageStored {
    languageCode.value = localStorageService.getLanguage();
    countryCode.value = localStorageService.getCountry();
    return (languageCode, countryCode);
  }

  /// gets the language locale app is set to
  Locale? get getLocale {
    var (language, country) = currentLanguageStored;
    if (language.value == '' && country.value == '') {
      ///set the locale to the device locale
      var languageCodeValidated =
          supportedLanguages.contains(Get.deviceLocale!.languageCode)
              ? Get.deviceLocale!.languageCode
              : defaultLanguage;
      var countryCodeValidated =
          supportedCountries.contains(Get.deviceLocale!.countryCode)
              ? Get.deviceLocale!.countryCode ?? defaultCountry
              : defaultCountry;
      languageCode.value = languageCodeValidated;
      countryCode.value = countryCodeValidated;
      updateLanguage(
        locale: languageCodeValidated,
        country: countryCodeValidated,
      );
    } else if (language.value != '' && country.value != '') {
      ///set the stored string country code to the locale
      return Locale(language.value, country.value);
    }

    /// gets the default language key for the system.
    return supportedLanguages.contains(Get.deviceLocale!.languageCode) &&
            supportedCountries.contains(Get.deviceLocale!.countryCode)
        ? Get.deviceLocale
        : const Locale(defaultLanguage, defaultCountry);
  }

  // updates the language stored
  Future<void> updateLanguage({
    required String locale,
    required String country,
  }) async {
    languageCode.value = locale;
    countryCode.value = country;
    await localStorageService.setLanguage(language: locale);
    await localStorageService.setCountry(country: country);
    await Get.updateLocale(getLocale!);
    update();
  }
}
