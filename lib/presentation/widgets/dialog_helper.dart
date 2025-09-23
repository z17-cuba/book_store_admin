import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  factory DialogHelper() => _instance;

  DialogHelper.internal();

  static final DialogHelper _instance = DialogHelper.internal();

  static void alertDialogCupertino(
    BuildContext context, {
    required String title,
    required String text,
    required String buttonOneText,
    required String buttonTwoText,
    required bool isButtonOneVisibity,
    required bool isButtonTwoVisibity,
    required void Function()? buttonOneFunction,
    required void Function()? buttonTwoFunction,
    TextStyle? textStyleTitle,
    TextStyle? textStyleText,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          title,
          style: textStyleTitle,
        ),
        content: Text(
          text,
          style: textStyleText,
        ),
        actions: <Widget>[
          Visibility(
            visible: isButtonOneVisibity,
            child: CupertinoDialogAction(
              onPressed: buttonOneFunction,
              child: Text(buttonOneText),
            ),
          ),
          Visibility(
            visible: isButtonTwoVisibity,
            child: CupertinoDialogAction(
              onPressed: buttonTwoFunction,
              child: Text(buttonTwoText),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> alertDialogMaterial(
    BuildContext context, {
    required String title,
    required String text,
    required bool isButtonOneVisibity,
    required bool isButtonTwoVisibity,
    required String buttonOneText,
    required String buttonTwoText,
    required void Function()? buttonOneFunction,
    required void Function()? buttonTwoFunction,
    TextStyle? textStyleTitle,
    TextStyle? textStyleText,
  }) async {
    await showDialog(
      context: context,
      barrierColor: AppColors.canvasColorBlack.withValues(alpha: 0.1),
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: textStyleTitle,
        ),
        content: Text(
          text,
          style: textStyleText,
        ),
        actions: <Widget>[
          Visibility(
            visible: isButtonOneVisibity,
            child: MaterialButton(
              onPressed: buttonOneFunction,
              child: Text(buttonOneText),
            ),
          ),
          Visibility(
            visible: isButtonTwoVisibity,
            child: MaterialButton(
              onPressed: buttonTwoFunction,
              child: Text(buttonTwoText),
            ),
          ),
        ],
      ),
    );
  }

  static void showDialogWithProgress(
    BuildContext context,
    String text,
    Color? backgroundColor,
    Color color,
  ) {
    final AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              color,
            ),
          ),
          Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => alert,
    );
  }

  static Future<void> alertDialogMaterialWithCustomContent(
    BuildContext context, {
    required String title,
    required Widget content,
    required bool isButtonOneVisibity,
    required bool isButtonTwoVisibity,
    required String buttonOneText,
    required String buttonTwoText,
    required void Function()? buttonOneFunction,
    required void Function()? buttonTwoFunction,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          Visibility(
            visible: isButtonOneVisibity,
            child: MaterialButton(
              onPressed: buttonOneFunction,
              child: Text(buttonOneText),
            ),
          ),
          Visibility(
            visible: isButtonTwoVisibity,
            child: MaterialButton(
              onPressed: buttonTwoFunction,
              child: Text(buttonTwoText),
            ),
          ),
        ],
      ),
    );
  }

  static void showDialogWithTextAndButtonCenter(
    BuildContext context, {
    required String title,
    required VoidCallback onPressed,
    TextStyle? textStyleTitle,
    TextStyle? textStyleText,
    required String textButton,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: textStyleTitle,
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
                left: 30,
                right: 30,
              ),
              child: PrimaryButton(
                title: textButton,
                isFilled: true,
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> alertDialogMaterialWithRichText(
    BuildContext context, {
    required Widget title,
    required Widget text,
    required bool isButtonOneVisibity,
    required bool isButtonTwoVisibity,
    required String buttonOneText,
    required String buttonTwoText,
    required void Function()? buttonOneFunction,
    required void Function()? buttonTwoFunction,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        title: title,
        content: text,
        actions: <Widget>[
          Visibility(
            visible: isButtonOneVisibity,
            child: MaterialButton(
              onPressed: buttonOneFunction,
              child: Text(buttonOneText),
            ),
          ),
          Visibility(
            visible: isButtonTwoVisibity,
            child: MaterialButton(
              onPressed: buttonTwoFunction,
              child: Text(buttonTwoText),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> openDialogFullScreen(
    BuildContext context,
    List<Widget> children,
    Color backgroundColor,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(20),
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }
}
