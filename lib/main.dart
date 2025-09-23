import 'package:book_store_admin/app.dart';
import 'package:book_store_admin/core/dependency_injection.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure URL strategy for web
  usePathUrlStrategy();

  await ScreenUtil.ensureScreenSize();

  await DependencyInjection.init();

  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
  );
}
