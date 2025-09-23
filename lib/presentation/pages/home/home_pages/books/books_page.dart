import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/books_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/categories_books_scroll_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BooksPage extends GetView<BooksController> {
  const BooksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooksController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(
          pagePaddingHorizontal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Book page header - Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'app.books'.tr,
                  style: textStyleAppBar,
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'app.refresh'.tr,
                      onPressed: () async => await controller
                          .loadBooksByLibrary(shouldRefresh: true),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedRefresh,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                    IconButton(
                      tooltip: 'app.addBook'.tr,
                      onPressed: () => controller.addBook(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedAddCircle,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                    IconButton(
                      tooltip: 'app.addAuthor'.tr,
                      onPressed: () => controller.addAuthor(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedUserAdd01,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                    IconButton(
                      tooltip: 'app.addPublisher'.tr,
                      onPressed: () => controller.addPublisher(context),
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedPenToolAdd,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Categories
            10.verticalSpace,
            const CategoriesBooksScrollWidget(),
            // Books table
            Expanded(
              child: SfDataGrid(
                allowSorting: true,
                controller: controller.dataGridController,
                placeholder: Center(
                  child: Text('app.noBooks'.tr),
                ),
                source: controller.booksDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                loadMoreViewBuilder: (
                  BuildContext context,
                  LoadMoreRows loadMoreRows,
                ) {
                  Future<String> loadRows() async {
                    await controller.loadBooksByLibrary();
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
                    width: iconSize * 1.5,
                    columnName: 'type',
                    label: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: pagePaddingHorizontal,
                        vertical: 8.0,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.type'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'title',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.title'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'authors',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.authorsPlural'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'isbn',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.isbn'.tr,
                        style: textStyleBodyBold,
                      ),
                    ),
                  ),
                  GridColumn(
                    minimumWidth: 110,
                    maximumWidth: 110,
                    columnName: 'status',
                    label: Container(
                      padding: const EdgeInsets.all(
                        pagePaddingHorizontal,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'app.status'.tr,
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
      ),
    );
  }
}
