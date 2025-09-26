import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/home_pages/authors_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AuthorsPage extends GetView<AuthorsController> {
  const AuthorsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthorsController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(
            pagePaddingHorizontal,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Authors page header - Actions
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
                        onPressed: () async =>
                            await controller.loadAuthorsByLibrary(
                          shouldRefresh: true,
                        ),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedRefresh,
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      IconButton(
                        tooltip: 'app.addAuthor'.tr,
                        onPressed: () =>
                            controller.addEditAuthor(context, null),
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
                    child: Text('app.noAuthors'.tr),
                  ),
                  source: controller.authorsDataGridSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  loadMoreViewBuilder: (
                    BuildContext context,
                    LoadMoreRows loadMoreRows,
                  ) {
                    Future<String> loadRows() async {
                      await controller.loadAuthorsByLibrary();
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
                      columnName: 'bio',
                      label: Container(
                        padding: const EdgeInsets.all(
                          pagePaddingHorizontal,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'app.bio'.tr,
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
      },
    );
  }
}
