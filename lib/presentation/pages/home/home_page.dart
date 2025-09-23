import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/home_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/widgets/change_language.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/widgets/hoverable_tab_widget.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/widgets/profile_options.dart';
import 'package:book_store_admin/presentation/routes/dashboard_item.dart';
import 'package:book_store_admin/presentation/routes/dashboard_items_config_admin.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HomePage extends GetView<HomeController> {
  final StatefulNavigationShell navigationShell;

  const HomePage({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    // Sync the controller's selected index with the navigation shell's current index.
    // This ensures the correct item is highlighted after a hot reload or deep link.
    controller.updateParentSelectedIndex(navigationShell.currentIndex);
    controller.updateChildSelectedIndexFromRoute(GoRouter.of(context));

    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width:
                    controller.showIconsOnly || !isDesktop ? 0.053.sw : 0.16.sw,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    right: BorderSide(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Divider(
                      height: 0,
                      color: AppColors.secondaryColor,
                      thickness: 3,
                    ),
                    4.0.verticalSpace,
                    Expanded(
                      child: menuList(context, isDesktop),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 0.081.sh,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            tooltip: controller.showIconsOnly
                                ? 'app.showTextAndIcons'.tr
                                : 'app.showIconsOnly'.tr,
                            onPressed: () {
                              controller.changeShowIconsOnly(
                                !controller.showIconsOnly,
                              );
                            },
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedHorizontalResize,
                              color: Theme.of(context).highlightColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const ChangeLanguage(),
                              4.horizontalSpace,
                              ProfileOptions(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: navigationShell,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget menuList(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: DashboardItemsConfigAdmin.items.length,
            itemBuilder: (BuildContext context, int index) {
              DashboardItem current = DashboardItemsConfigAdmin.items[index];
              bool isSelected = index == controller.currentParentPage;
              return HoverableTabWidget(
                builder: (isHover) {
                  Color color =
                      isHover ? AppColors.grey400 : AppColors.canvasColorWhite;

                  if (current.pageChilds.isNotEmpty) {
                    return ExpansionTile(
                      tilePadding:
                          const EdgeInsets.only(left: 21.0, right: 16.0),
                      onExpansionChanged: (value) => controller.showIconsOnly
                          ? controller.changeShowIconsOnly(false)
                          : null,
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: current.icon,
                            color: Theme.of(context).highlightColor,
                            size: 0.02.sw,
                          ),
                          if (!controller.showIconsOnly) 4.0.horizontalSpace,
                        ],
                      ),
                      title: controller.showIconsOnly || !isDesktop
                          ? const SizedBox.shrink()
                          : Text(
                              current.title(),
                              style: textStyleButton.apply(
                                color: isSelected
                                    ? AppColors.secondaryColor
                                    : color,
                              ),
                            ),
                      trailing: controller.showIconsOnly || !isDesktop
                          ? Icon(
                              Icons.keyboard_arrow_right_sharp,
                              size: 16,
                              color:
                                  isSelected ? AppColors.secondaryColor : color,
                            )
                          : Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 16,
                              color:
                                  isSelected ? AppColors.secondaryColor : color,
                            ),
                      children: controller.showIconsOnly || !isDesktop
                          ? []
                          : [
                              subMenuList(
                                index,
                                current.pageChilds,
                              )
                            ],
                    );
                  } else {
                    return Row(
                      children: [
                        Container(
                          width: 6.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondaryColor
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              bottomRight: Radius.circular(6.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MouseRegion(
                            key: const Key('HomePage - MouseRegion'),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                String url = GoRouter.of(context)
                                    .routeInformationProvider
                                    .value
                                    .uri
                                    .path;
                                if (!url.endsWith(current.routePath)) {
                                  //estoy dentro de una subruta del branch
                                  NavigatorHelper.toNamed(current.routeName);
                                } else {
                                  //cambio el branch, es un parent, con cambiar el branch ya
                                  navigationShell.goBranch(index);
                                }

                                //actualizo el indice
                                controller.updateParentSelectedIndex(index);
                              },
                              child: controller.showIconsOnly || !isDesktop
                                  ? HugeIcon(
                                      icon: current.icon,
                                      color: Theme.of(context).highlightColor,
                                      size: 0.02.sw,
                                    )
                                  : ListTile(
                                      horizontalTitleGap: 12.0,
                                      mouseCursor: SystemMouseCursors.click,
                                      leading: HugeIcon(
                                        icon: current.icon,
                                        color: Theme.of(context).highlightColor,
                                        size: 0.02.sw,
                                      ),
                                      title: Text(
                                        current.title(),
                                        style: textStyleButton.apply(
                                          color: isSelected
                                              ? AppColors.secondaryColor
                                              : color,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            },
          ),
        ),
        Column(
          children: [
            20.verticalSpace,
            Text(
              'v. ${controller.packageInfo.version}',
              style: textStyleBodyBold.copyWith(
                color: Theme.of(context).highlightColor,
              ),
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
          ],
        )
      ],
    );
  }

  Widget subMenuList(int parentIndex, List<DashboardChildItem> childs) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: childs.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => HoverableTabWidget(
        builder: (isHover) {
          Color color = isHover
              ? AppColors.secondaryColor
              : Theme.of(context).canvasColor;

          DashboardChildItem current = childs[index];
          bool isSelected = parentIndex == controller.currentParentPage &&
              index == controller.currentChildPage;
          return Row(
            children: [
              Container(
                width: 6.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -3),
                  mouseCursor: SystemMouseCursors.click,
                  contentPadding: const EdgeInsets.only(left: 58.0),
                  title: Text(
                    current.title(),
                    style: textStyleBody.apply(
                      color: isSelected ? AppColors.secondaryColor : color,
                    ),
                  ),
                  onTap: () {
                    //navega al child, es una navegacion, NO un cambio de branch, el branch es el parent, los child es navegacion normal
                    NavigatorHelper.toNamed(current.routeName);
                    //se actualiza el index del child seleccionado para pintarlo
                    controller.updateChildSelectedIndex(
                      parentIndex: parentIndex,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
