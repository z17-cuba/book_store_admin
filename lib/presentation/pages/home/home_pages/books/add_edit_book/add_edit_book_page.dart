import 'dart:typed_data';

import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/core/validator.dart';
import 'package:book_store_admin/core/auxiliary_functions.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/domain/models/audiobook_domain.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';
import 'package:book_store_admin/domain/models/ebook_domain.dart';
import 'package:book_store_admin/domain/models/tag_domain.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/app/theme/colors.dart';
import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:book_store_admin/presentation/controllers/add_entities/add_edit_book_controller.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/widgets/upload_file_card.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/widgets/upload_image_card.dart';
import 'package:book_store_admin/presentation/widgets/custom_text_form_field.dart';
import 'package:book_store_admin/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AddEditBookPage extends GetView<AddEditBookController> {
  const AddEditBookPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) {
        if (didPop) return;
        controller.goBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => controller.goBack(context),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).highlightColor,
            ),
          ),
          title: Text(
            controller.bookId == null ? 'app.createBook'.tr : 'app.editBook'.tr,
            style: textStyleButtonBold,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(pagePaddingHorizontal),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                0.01.sh.verticalSpace,
                Text(
                  'app.requiredFields'.tr,
                  style: textStyleAppBar.copyWith(
                    color: Theme.of(context).highlightColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                // Thumbnail
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => CircleImageCard(
                          imageUrl: controller.book?.thumbnailUrl,
                          imageBytes:
                              controller.thumbnailBytes?.value ?? Uint8List(0),
                          onSelectNewFile: () async =>
                              await controller.selectThumbnail(),
                        ),
                      ),
                    ),
                    20.horizontalSpace,
                    // Language - ISBN - PageCount
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextFormField(
                          controller: controller.languageController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          labelText: 'app.language'.tr,
                          prefixIcon: HugeIcon(
                            icon: HugeIcons.strokeRoundedLanguageSquare,
                            color: Theme.of(context).highlightColor,
                          ),
                          hintText: 'es',
                          suffixIcon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAsterisk02,
                            color: AppColors.redError,
                          ),
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) => Validator.notEmpty(
                            value,
                            'app.fieldIsEmpty'.tr,
                          ),
                        ),
                        20.verticalSpace,
                        CustomTextFormField(
                          controller: controller.isbnController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          labelText: 'app.isbn'.tr,
                          maxLines: 2,
                          prefixIcon: HugeIcon(
                            icon: HugeIcons.strokeRoundedInformationCircle,
                            color: Theme.of(context).highlightColor,
                          ),
                          suffixIcon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedAsterisk02,
                            color: AppColors.redError,
                          ),
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) => Validator.isbn(
                            value,
                            'app.fieldIsEmpty'.tr,
                            'app.notValidIsbn'.tr,
                          ),
                        ),
                        20.verticalSpace,
                        CustomTextFormField(
                          controller: controller.pageCountController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          labelText: 'app.pages'.tr,
                          prefixIcon: HugeIcon(
                            icon: HugeIcons.strokeRoundedBookOpen02,
                            color: Theme.of(context).highlightColor,
                          ),
                          labelTextColor: Theme.of(context).highlightColor,
                          validator: (value) =>
                              Validator.validateNotRequiredNumber(
                            value,
                            'app.fieldIsNotANumber'.tr,
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                20.verticalSpace,
                // Title
                CustomTextFormField(
                  controller: controller.titleController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.title'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedIdentityCard,
                    color: Theme.of(context).highlightColor,
                  ),
                  suffixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedAsterisk02,
                    color: AppColors.redError,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                  validator: (value) => Validator.notEmpty(
                    value,
                    'app.fieldIsEmpty'.tr,
                  ),
                ),
                20.verticalSpace,
                // Subtitle
                CustomTextFormField(
                  controller: controller.subtitleController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  labelText: 'app.subtitle'.tr,
                  maxLines: 2,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMenu01,
                    color: Theme.of(context).highlightColor,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                ),
                20.verticalSpace,
                // Description
                CustomTextFormField(
                  controller: controller.descriptionController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  maxLines: 5,
                  labelText: 'app.description'.tr,
                  prefixIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedTextAlignCenter,
                    color: Theme.of(context).highlightColor,
                  ),
                  labelTextColor: Theme.of(context).highlightColor,
                ),
                20.verticalSpace,
                // Authors
                Obx(
                  () => controller.isLoadingAuthors.value
                      ? const CircularProgressIndicator()
                      : _buildMultiSelect<AuthorDomain>(
                          context: context,
                          label: 'app.authorsPlural'.tr,
                          items: controller.authors,
                          selectedItems: controller.selectedAuthors,
                          onConfirm: (values) {
                            controller.selectedAuthors.assignAll(values);
                          },
                          displayItem: (author) => author.fullName,
                        ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    // Tags
                    Expanded(
                      child: Obx(
                        () => controller.isLoadingTags.value
                            ? const Center(child: CircularProgressIndicator())
                            : _buildMultiSelect<TagDomain>(
                                context: context,
                                label: 'app.tags'.tr,
                                items: controller.tags,
                                selectedItems: controller.selectedTags,
                                onConfirm: (values) {
                                  controller.selectedTags.assignAll(values);
                                },
                                displayItem: (tag) => tag.name ?? '',
                              ),
                      ),
                    ),
                    20.horizontalSpace,
                    // Categories
                    Expanded(
                      child: Obx(
                        () => controller.isLoadingCategories.value
                            ? const Center(child: CircularProgressIndicator())
                            : _buildMultiSelect<CategoryDomain>(
                                context: context,
                                label: 'app.categories'.tr,
                                items: controller.categories,
                                selectedItems: controller.selectedCategories,
                                onConfirm: (values) {
                                  controller.selectedCategories
                                      .assignAll(values);
                                },
                                displayItem: (category) =>
                                    'app.${category.name}'.tr,
                              ),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                // Content Rating - Status
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<BookContentRating>(
                        context: context,
                        label: 'app.contentRating'.tr,
                        value: controller.contentRating.value,
                        items: BookContentRating.values,
                        onChanged: (val) {
                          if (val != null) {
                            controller.contentRating.value = val;
                          }
                        },
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: _buildDropdown<BookStatus>(
                        context: context,
                        label: 'app.status'.tr,
                        value: controller.status.value,
                        items: BookStatus.values,
                        onChanged: (val) {
                          if (val != null) controller.status.value = val;
                        },
                      ),
                    ),
                  ],
                ),

                20.verticalSpace,
                // Book Type
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => controller.isLoadingPublishers.value
                            ? const CircularProgressIndicator()
                            : controller.publisher.value != null
                                ? _buildDropdown<PublisherModel>(
                                    context: context,
                                    label: 'app.publisher'.tr,
                                    value: controller.publisher.value!,
                                    items: controller.publishers,
                                    onChanged: (val) {
                                      if (val != null) {
                                        controller.publisher.value = val;
                                      }
                                    },
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'app.type'.tr,
                              style: textStyleAppBar,
                            ),
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: Obx(
                              () => _buildDropdown<BookType>(
                                context: context,
                                label: 'app.type'.tr,
                                value: controller.type.value,
                                items: BookType.values
                                    .sublist(1, BookType.values.length),
                                onChanged: (val) {
                                  if (val != null) controller.type.value = val;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Obx(
                  () => UploadFileCard(
                    title: controller.type.value == BookType.ebook
                        ? 'app.uploadAnEbook'.tr
                        : 'app.uploadAnAudiobook'.tr,
                    helperText: controller.type.value == BookType.ebook
                        ? 'app.pressTheIconToUploadAnEbook'.tr
                        : 'app.pressTheIconToUploadAnAudiobook'.tr,
                    onSelectNewFile: () => controller.selectFile(context),
                    fileName: controller.selectedFile.value != null
                        ? controller.selectedFile.value?.name
                        : controller.book != null
                            ? (controller.book?.bookType == BookType.ebook
                                ? (controller.book as EbookDomain).fileName
                                : (controller.book as AudiobookDomain).fileName)
                            : null,
                    fileSize: controller.selectedFile.value != null
                        ? '${(controller.selectedFile.value!.size / (1024 * 1024)).toStringAsFixed(2)} MB'
                        : controller.fileSizeMb.value != 0.0
                            ? '${controller.fileSizeMb.value} MB'
                            : null,
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => controller.type.value == BookType.audiobook
                      ? Column(
                          children: [
                            // Narrator name - Total Duration
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    controller:
                                        controller.narratorNameController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    labelText: 'app.narratorName'.tr,
                                    prefixIcon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMenu01,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                    suffixIcon: const HugeIcon(
                                      icon: HugeIcons.strokeRoundedAsterisk02,
                                      color: AppColors.redError,
                                    ),
                                    labelTextColor:
                                        Theme.of(context).highlightColor,
                                    validator: (value) => Validator.notEmpty(
                                      value,
                                      'app.fieldIsEmpty'.tr,
                                    ),
                                  ),
                                ),
                                20.horizontalSpace,
                                Expanded(
                                  child: CustomTextFormField(
                                    controller: controller.durationController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    labelText: 'app.totalDurationInSeconds'.tr,
                                    prefixIcon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMenu01,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                    labelTextColor:
                                        Theme.of(context).highlightColor,
                                  ),
                                ),
                              ],
                            ),
                            20.verticalSpace,
                            // Samplerate - Bitrate
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    controller: controller.sampleRateController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    labelText: 'app.sampleRate'.tr,
                                    prefixIcon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMenu01,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                    labelTextColor:
                                        Theme.of(context).highlightColor,
                                  ),
                                ),
                                20.horizontalSpace,
                                Expanded(
                                  child: CustomTextFormField(
                                    controller: controller.bitRateController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    labelText: 'app.bitrate'.tr,
                                    prefixIcon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMenu01,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                    labelTextColor:
                                        Theme.of(context).highlightColor,
                                  ),
                                ),
                              ],
                            ),
                            20.verticalSpace,
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () => PrimaryButton(
                    onPressed: () => controller.createOrUpdateBook(context),
                    expand: false,
                    isValid: controller.selectedFile.value != null,
                    title: controller.bookId == null
                        ? 'app.createBook'.tr
                        : 'app.editBook'.tr,
                    isFilled: true,
                    color: Theme.of(context).highlightColor,
                    textColor: Theme.of(context).canvasColor,
                  ),
                ),
                30.verticalSpace,
              ],
            ), // Form
          ), // SingleChildScrollView
        ),
      ),
    ); // Scaffold
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.grey200,
          ),
          borderRadius: BorderRadius.circular(
            roundCornerRadius,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            (item is Enum)
                ? AuxiliaryFunctions.getMatchStringToLocale((item as Enum).name)
                    .tr
                : (item is PublisherModel)
                    ? (item.name ?? '')
                    : item.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMultiSelect<T>({
    required BuildContext context,
    required String label,
    required List<T> items,
    required List<T> selectedItems,
    required Function(List<T>) onConfirm,
    required String Function(T) displayItem,
  }) {
    return InkWell(
      onTap: () async {
        final List<T>? result = await showDialog<List<T>>(
          context: context,
          builder: (BuildContext context) {
            final List<T> tempSelectedItems = List<T>.from(selectedItems);
            return AlertDialog(
              title: Text(label),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    width: 0.4.sw,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final bool isSelected =
                            tempSelectedItems.contains(item);
                        return CheckboxListTile(
                          title: Text(displayItem(item)),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                tempSelectedItems.add(item);
                              } else {
                                tempSelectedItems.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('app.cancel'.tr),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('app.accept'.tr),
                  onPressed: () => Navigator.of(context).pop(tempSelectedItems),
                ),
              ],
            );
          },
        );
        if (result != null) {
          onConfirm(result);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundCornerRadius),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          selectedItems.isEmpty
              ? ''
              : selectedItems.map(displayItem).join(', '),
          style: textStyleBody.copyWith(
            color: Theme.of(context).highlightColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
