RegExp emailValidationRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

RegExp urlValidatorRegEx = RegExp(r'^https?:\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$');

/// Regex for ISBN-10:
/// - 9 digits + 1 check digit (0–9 or X/x)
RegExp isbn10 = RegExp(r'^\d{9}[\dXx]$');

/// Regex for ISBN-13:
/// - 13 digits only
RegExp isbn13 = RegExp(r'^\d{13}$');
