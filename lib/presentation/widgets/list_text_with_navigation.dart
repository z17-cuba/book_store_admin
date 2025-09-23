import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ListTextWithNavigation extends StatelessWidget {
  const ListTextWithNavigation({
    required this.textOne,
    required this.texts,
    required this.textAlign,
    this.textStyleTextOne,
    super.key,
  });

  final String textOne;
  final List<TextWithTap> texts;
  final TextStyle? textStyleTextOne;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: '$textOne ',
          style: textStyleTextOne,
          children: texts
              .map(
                (e) => TextSpan(
                  text: e.text,
                  recognizer: TapGestureRecognizer()..onTap = e.onTap,
                  style: e.textStyle,
                ),
              )
              .toList(),
        ),
      );
}

class TextWithTap {
  TextWithTap({required this.text, this.textStyle, this.key, this.onTap});

  final String text;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final String? key;
}
