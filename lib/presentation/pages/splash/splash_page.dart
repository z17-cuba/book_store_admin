import 'package:book_store_admin/presentation/app/constants/assets.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) => Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.canvasColorWhite,
        body: Center(
          child: Image.asset(
            Assets.assetsIconAppIconApp,
            height: 0.5.sh,
            width: 0.5.sh,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
