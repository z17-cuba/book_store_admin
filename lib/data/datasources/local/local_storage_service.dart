import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService({
    required this.preferences,
  });

  final SharedPreferences preferences;

  Future<void> clearTokenData() async {
    try {
      Future.wait([
        //Token vars
        preferences.remove(sharedPrefAccessToken),
        preferences.remove(sharedPrefRefreshToken),
      ]);
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on clearTokenData',
      );
    }
  }

  Future<void> clearAllData() async {
    //Future.wait([]);
  }

  //Language

  Future<void> setLanguage({
    required String language,
  }) async {
    try {
      await preferences.setString(
        sharedPrefLanguage,
        language,
      );
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on setLanguage',
      );
    }
  }

  String getLanguage() {
    try {
      return preferences.getString(sharedPrefLanguage) ?? '';
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on getLanguage',
      );
    }
  }

  Future<void> setCountry({
    required String country,
  }) async {
    try {
      await preferences.setString(
        sharedPrefCountry,
        country,
      );
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on setCountry',
      );
    }
  }

  String getCountry() {
    try {
      return preferences.getString(sharedPrefCountry) ?? '';
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on getCountry',
      );
    }
  }

  String getThemeMode() {
    try {
      return preferences.getString(sharedPrefTheme) ?? 'light';
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on getThemeMode',
      );
    }
  }

  Future<void> setThemeMode({
    required String themeMode,
  }) async {
    try {
      await preferences.setString(
        sharedPrefTheme,
        themeMode,
      );
    } catch (e) {
      throw CustomException(
        code: sharedPrefErrorCode,
        errorMessage: 'Error on setThemeMode',
      );
    }
  }
}
