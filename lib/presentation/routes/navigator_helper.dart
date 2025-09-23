import 'package:book_store_admin/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NavigatorHelper {
  //asumed `goNamed`
  static Future toNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    bool addToStack = true,
    BuildContext? context,
  }) async {
    return (context ?? Global.context).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  //asumed `goNamed`
  static void toNamedWithoutAwait(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    bool addToStack = true,
    BuildContext? context,
  }) {
    return (context ?? Global.context).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void go(
    String location, {
    BuildContext? context,
  }) {
    (context ?? Get.context!).go(location);
  }

  static Future offAllNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    bool addToStack = true,
    BuildContext? context,
  }) async {
    return (context ?? Global.context).pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static Future pushNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    bool addToStack = true,
    BuildContext? context,
  }) async {
    return (context ?? Get.context)?.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void pop({
    BuildContext? context,
  }) {
    (context ?? Global.context).pop();
  }

  /// Para cerrar los dialogs es con el Navigator nativo de Flutter porque ellos
  /// se abren con el Navigator nativo de Flutter
  static void closeDialog({
    BuildContext? context,
  }) {
    Navigator.of(context ?? Global.context).pop();
  }
}
