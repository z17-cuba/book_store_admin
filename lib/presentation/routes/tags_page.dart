import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/tags_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TagsPage extends GetView<TagsController> {
  const TagsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TagsController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(
          pagePaddingHorizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tags page header - Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'app.tags'.tr,
                  style: textStyleAppBar,
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'app.refresh'.tr,
                      onPressed: () async => await controller.loadTagsByLibrary(
                        shouldRefresh: true,
                      ),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedRefresh,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                    IconButton(
                      tooltip: 'app.addTag'.tr,
                      onPressed: () => controller.addEditTag(context, null),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedAddCircle,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Categories
            10.verticalSpace,
            // Tags table
            Expanded(
              child: SfDataGrid(
                allowSorting: true,
                controller: controller.dataGridController,
                placeholder: Center(
                  child: Text('app.noTags'.tr),
                ),
                source: controller.tagsDataGridSource,
                columnWidthMode: ColumnWidthMode.fill,
                loadMoreViewBuilder: (
                  BuildContext context,
                  LoadMoreRows loadMoreRows,
                ) {
                  Future<String> loadRows() async {
                    await controller.loadTagsByLibrary();
                    return Future<String>.value('Completed');
                  }

                  return FutureBuilder<String>(
                    initialData: 'loading',
                    future: loadRows(),
                    builder: (context, snapShot) {
                      if (snapShot.data == 'loading') {
                        return Container(
                          height: 98.0,
                          color: Colors.white,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.secondaryColor,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                },
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'name',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.name'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                  GridColumn(
                    width: iconSize * 5,
                    allowSorting: false,
                    columnName: 'actions',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.actions'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
