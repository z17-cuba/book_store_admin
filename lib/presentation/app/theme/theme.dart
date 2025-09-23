import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: AppColors.primaryColor,
    selectionColor: AppColors.primaryColor.withValues(alpha: 0.3),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryColor,
  ),
  tabBarTheme: TabBarTheme(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primaryColor.withValues(alpha: 0.1);
      }
      return null;
    }),
    indicatorColor: AppColors.primaryColor,
    labelColor: AppColors.primaryColor,
  ),
  cardTheme: const CardTheme(
    color: AppColors.canvasColorWhite,
  ),
  scaffoldBackgroundColor: AppColors.scaffoldColorWhite,
  canvasColor: AppColors.canvasColorWhite,
  cardColor: AppColors.canvasColorWhite,
  textTheme: _buildTextTheme(
    AppColors.textLightTheme,
    AppColors.subtextLightTheme,
  ),
  highlightColor: AppColors.textLightTheme,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundCornerRadius / 2),
        ),
      ),
    ),
  ),
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.secondaryColor,
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: AppColors.primaryColor,
    selectionColor: AppColors.primaryColor.withValues(alpha: 0.3),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryColor,
  ),
  tabBarTheme: TabBarTheme(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppColors.primaryColor.withValues(alpha: 0.1);
      }
      return null;
    }),
    indicatorColor: AppColors.primaryColor,
    labelColor: AppColors.primaryColor,
  ),
  cardTheme: const CardTheme(
    color: AppColors.canvasColorBlack,
  ),
  scaffoldBackgroundColor: AppColors.scaffoldColorBlack,
  canvasColor: AppColors.canvasColorBlack,
  cardColor: AppColors.canvasColorBlack,
  textTheme: _buildTextTheme(
    AppColors.textDarkTheme,
    AppColors.subtextDarkTheme,
  ),
  highlightColor: AppColors.textDarkTheme,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundCornerRadius / 2),
        ),
      ),
    ),
  ),
);

// Helper function to build text theme with proper colors
TextTheme _buildTextTheme(Color textColor, Color subtextColor) {
  return TextTheme(
    // Titles
    titleLarge: textStyleAppBar.copyWith(color: textColor),
    titleMedium: textStyleTitle.copyWith(color: textColor),
    titleSmall: textStyleBody.copyWith(color: textColor),
    displayLarge: textStyleAppBar.copyWith(color: textColor),
    displayMedium: textStyleTitle.copyWith(color: textColor),
    displaySmall: textStyleBody.copyWith(color: textColor),
    // Body
    bodyLarge: textStyleBodyBold.copyWith(color: textColor),
    bodyMedium: textStyleBody.copyWith(color: textColor),
    bodySmall: textStyleBodySmall.copyWith(color: textColor),
    // Captions
    labelLarge: textStyleButton.copyWith(color: subtextColor),
    labelMedium: textStyleBodyBold.copyWith(color: subtextColor),
    labelSmall: textStyleBodySmall.copyWith(color: subtextColor),
  );
}
