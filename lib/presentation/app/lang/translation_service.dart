import 'dart:ui';

import 'package:get/get.dart';
import 'en_unit_state.dart';
import 'es_espanna.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'es_ES': esEs,
      };

  Iterable<Locale> get supportedLocales => [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ];
}

extension TransWithGender on String {
  ///Comparison againts getGenderList to replace vowel given a gender
  String trWithGender(String key, {String? gender}) {
    // Determine the vowel based on gender
    String vowel;
    switch (gender?.toLowerCase()) {
      case 'man':
        vowel = 'o';
        break;
      case 'woman':
        vowel = 'a';
        break;
      case 'nonBinary':
      default:
        vowel = 'x';
        break;
    }

    // Use Getx's interpolation feature
    return key.trParams({'vowel': vowel});
  }
}
