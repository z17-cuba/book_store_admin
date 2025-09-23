import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.enabled = true,
    this.controller,
    this.enableSuggestions = true,
    this.showCounter,
    this.autocorrect = true,
    this.autovalidateMode,
    this.keyboardType,
    this.focusNode,
    this.validator,
    this.obscureText = false,
    this.autofocus = false,
    this.textCapitalization,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.labelText,
    this.labelTextColor,
    this.hintText,
    this.disabledBorderColor,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.error,
    this.scrollPadding =
        const EdgeInsets.all(20.0), //same default value as original component
  });

  final bool enabled;
  final TextEditingController? controller;
  final bool enableSuggestions;
  final bool autocorrect;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool? showCounter;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? labelText;
  final Color? labelTextColor;
  final String? hintText;
  final Color? disabledBorderColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? error;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: scrollPadding,
      enabled: enabled,
      controller: controller,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: keyboardType,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: validator,
      obscureText: obscureText,
      cursorColor: Colors.black,
      maxLines: maxLines,
      minLines: minLines ?? ((maxLines ?? 1) > 1 ? 1 : null),
      onFieldSubmitted:
          onSubmitted != null ? (value) => onSubmitted!(value) : null,
      onChanged: onChanged,
      maxLength: maxLength,
      style: textStyleAppBar,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16) +
            const EdgeInsets.symmetric(vertical: 8),
        filled: true,
        fillColor: enabled
            ? Theme.of(context).scaffoldBackgroundColor
            : AppColors.grey150,
        counter: showCounter != null && showCounter!
            ? null
            : const SizedBox.shrink(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.grey200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.grey200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.grey400,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.redError,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.redError,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
          borderSide: BorderSide(
            color: disabledBorderColor ?? AppColors.grey150,
          ),
        ),
        hintStyle: textStyleAppBar.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        hintText: hintText,
        label: labelText != null
            ? Text(
                labelText!,
                style: textStyleAppBar.copyWith(
                  color: labelTextColor,
                ),
              )
            : null,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        error: error,
      ),
    );
  }
}
