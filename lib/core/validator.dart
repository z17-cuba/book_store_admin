import 'package:book_store_admin/core/regex_validations.dart';

class Validator {
  Validator();

  static String? email(String? value, String messageInvalidEmail) {
    if (!emailValidationRegEx.hasMatch(value!)) {
      return messageInvalidEmail;
    } else {
      return null;
    }
  }

  static String? validatePassword(
    String? value,
    String emptyString,
    String messageInvalidPassword,
  ) {
    if (value == null || value.isEmpty) {
      return emptyString;
    } else if ((value.length < 8)) {
      return messageInvalidPassword;
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword({
    required String? value,
    required String emptyString,
    required String password,
    required String messageInvalidPassword,
  }) {
    if (value == null || value.isEmpty) {
      return emptyString;
    } else if (value.compareTo(password) != 0) {
      return messageInvalidPassword;
    } else {
      return null;
    }
  }

  static String? url(
    String? value,
    String invalidUrlMessage,
  ) {
    if (!urlValidatorRegEx.hasMatch(value!)) {
      return invalidUrlMessage;
    } else {
      return null;
    }
  }

  static String? notEmpty(String? value, String emptyString) {
    if (value == null || value.isEmpty) {
      return emptyString;
    } else {
      return null;
    }
  }

  ///Validation for number fields that are not required
  static String? validateNotRequiredNumber(
    String? value,
    String notNumberString,
  ) {
    // Regular expression pattern to match numbers
    RegExp regex = RegExp(r'^[0-9]+$');

    if (value != null && value.isNotEmpty && !regex.hasMatch(value)) {
      // Return an error message if the input contains non-numeric characters
      return notNumberString;
    }

    // Return null if the input is valid
    return null;
  }
}
