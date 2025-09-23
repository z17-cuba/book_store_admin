import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.title,
    required this.isFilled,
    this.isValid = true,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expand = true,
    this.forIcon = false,
    this.leadingIcon,
    this.trailingIcon,
    this.buttonHeight,
    this.size,
    this.color = AppColors.primaryColor,
    this.textColor,
  });

  final String title;
  final bool isFilled;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isValid;
  final bool expand;
  final bool forIcon;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final ButtonHeight? buttonHeight;
  final Size? size;
  final Color color;
  final Color? textColor;

  Widget _getLabel(BuildContext context) =>
      isLoading ? _getLoadingIndicator() : _getLabelWidget(context);

  Widget _getLoadingIndicator() => const SizedBox.square(
        dimension: 16,
        child: CircularProgressIndicator(color: Colors.white),
      );

  Widget _getLabelWidget(BuildContext context) => forIcon
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: leadingIcon,
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            leadingIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: leadingIcon!,
                  )
                : const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: textStyleButton.copyWith(
                  color: isValid ? textColor : AppColors.shimmerBaseColor,
                ),
              ),
            ),
            trailingIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: trailingIcon!,
                  )
                : const SizedBox(width: 8),
          ],
        );

  double buttonHeightCalc(ButtonHeight? buttonHeight) => switch (buttonHeight) {
        (ButtonHeight.small) => smallButtonSizeHeight,
        (ButtonHeight.normal) => normalButtonSizeHeight,
        (ButtonHeight.big) => bigButtonSizeHeight,
        _ => smallButtonSizeHeight,
      };

  ButtonStyle _getButtonStyle() {
    final minimumSize = size ??
        (forIcon
            ? const Size(50, 50)
            : expand
                ? Size(double.infinity, buttonHeightCalc(buttonHeight))
                : Size(200, buttonHeightCalc(buttonHeight)));
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    final padding = forIcon
        ? const EdgeInsets.all(5)
        : const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5);

    if (isFilled) {
      return ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        backgroundColor: isValid ? color : AppColors.shimmerBaseColor,
        shape: shape,
        padding: padding,
      );
    } else {
      return OutlinedButton.styleFrom(
        foregroundColor: !isFilled ? AppColors.primaryColor : null,
        minimumSize: minimumSize,
        shape: shape,
        side: BorderSide(
          width: 2,
          color: color,
        ),
        padding: padding,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: forIcon ? null : 0.07.sh,
      child: isFilled
          ? ElevatedButton(
              style: _getButtonStyle(),
              onPressed: !isLoading && isValid ? onPressed : null,
              child: _getLabel(context),
            )
          : OutlinedButton(
              style: _getButtonStyle(),
              onPressed: !isLoading ? onPressed : null,
              child: _getLabel(context),
            ),
    );
  }
}

enum ButtonHeight { small, normal, big }
