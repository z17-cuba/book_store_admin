import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordVisibility extends StatelessWidget {
  const PasswordVisibility({
    required this.color,
    required this.isVisible,
    VoidCallback? onPressed,
    super.key,
  }) : _onPressed = onPressed;

  final VoidCallback? _onPressed;
  final bool isVisible;
  final Color color;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onPressed,
        child: isVisible
            ? HugeIcon(
                icon: HugeIcons.strokeRoundedView,
                color: Theme.of(context).highlightColor,
              )
            : HugeIcon(
                icon: HugeIcons.strokeRoundedViewOff,
                color: Theme.of(context).highlightColor,
              ),
      );
}
