import 'package:flutter/material.dart';

class AppColors {
  //Main Theme Colors
  ///Trustworthy, calm, excellent for dark/nav UI
  static const primaryColor = Color(0xff031E56);

  ///Highlight actions (e.g. play, checkout, CTA)
  static const secondaryColor = Color(0xff3EA789);

  ///For links, playback progress, badges
  static const accentColor = Color(0xff87CF47);

  //Other Colors
  ///Success messages
  static const greenSuccess = Color(0xff10B981); //Green 500
  ///Warnings
  static const yellowWarning = Color(0xffFACC15); //Yellow 400
  ///Validation errors
  static const redError = Color(0xffEF4444); //Red 500

  static final shimmerBaseColor = AppColors.grey600.withValues(alpha: 0.3);
  static const shimmerHighlightColor = Color(0xffEFEFEF);
  static const transparentBackground = Color(0x00000000);
  //Scaffold
  static const scaffoldColorWhite = Color(0xffF9FAFB); //Gray-50
  static const scaffoldColorBlack = Color(0xff1F2937); //Gray-800
  //Canvas
  static const canvasColorWhite = Color(0xffF3F4F6); //Gray-100
  static const canvasColorBlack = Color(0xFF252529);
  //Texts
  ///High contrast for readability
  static const textLightTheme = Color(0xff111827); //Gray-900
  static const textDarkTheme = Color(0xffF9FAFB); //Gray-900
  ///Subheadings, timestamps, hints
  static const subtextLightTheme = Color(0xff6B7280); //Gray-500
  static const subtextDarkTheme = Color(0xff9CA3AF); //Gray-500

  // Grey
  static const grey = Color(0xFF808080); // Grey 500
  static const grey100 = Color(0xFFF9F9F9); // Grey 100
  static const grey150 = Color(0xFFEDEDED); // Grey 100
  static const grey200 = Color(0xFFCCCCCC); // Grey 200
  static const grey400 = Color(0xFF999999); // Grey 400
  static const grey600 = Color(0xFF595959); // Grey 600
  static const grey800 = Color(0xFF333333); // Grey 800
  static const grey900 = Color(0xFF191919); // Grey 900
}
