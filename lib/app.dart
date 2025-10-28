import 'dart:ui';

import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/core/logger/logger_utils.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/lang/translation_service.dart';
import 'package:book_store_admin/presentation/app/theme/theme.dart';
import 'package:book_store_admin/presentation/controllers/language/language_controller.dart';
import 'package:book_store_admin/presentation/routes/route_config.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetBuilder<LanguageController>(
      builder: (languageController) => ScreenUtilInit(
        //ScreenUtilInit
        minTextAdapt: true,
        builder: (context, widget) => LoadingOverlay.buildGlobal(
          GetMaterialApp.router(
            builder: (context, widget) => MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(),
              child: widget!,
            ),
            title: nameWebPanel,
            debugShowCheckedModeBanner: false,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.unknown
              },
            ),
            // Logging
            enableLog: true,
            logWriterCallback: LoggerUtils.write,
            // End Logging
            //Theme
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: EasyDynamicTheme.of(context).themeMode!,
            //End Theme
            // Routes
            routeInformationParser: RouteConfig.router.routeInformationParser,
            routerDelegate: RouteConfig.router.routerDelegate,
            routeInformationProvider:
                RouteConfig.router.routeInformationProvider,
            // End Routes
            // Locale
            locale: languageController.getLocale,
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            translations: TranslationService(),
            supportedLocales: TranslationService().supportedLocales,
            // End Locale
          ),
        ),
      ),
    );
  }
}

class Global {
  static BuildContext get context => navigatorKey.currentContext!;

  static NavigatorState get navigator => navigatorKey.currentState!;
}
