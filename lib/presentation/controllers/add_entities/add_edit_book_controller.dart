import 'dart:async';
import 'dart:typed_data';

import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/domain/mapper/tags_mapper.dart';
import 'package:book_store_admin/domain/models/audiobook_domain.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';
import 'package:book_store_admin/domain/models/ebook_domain.dart';
import 'package:book_store_admin/domain/models/general_book_domain.dart';
import 'package:book_store_admin/domain/models/tag_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/domain/repositories/categories_repository.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEditBookController extends GetxController {
  AddEditBookController({
    this.book,
    this.bookId,
    required this.categoriesRepository,
    required this.tagsDatasource,
    required this.publisherDatasource,
    required this.authorRepository,
    required this.bookRepository,
    required this.userController,
  });

  final BookRepository bookRepository;
  final UserController userController;
  final CategoriesRepository categoriesRepository;
  final TagsDatasource tagsDatasource;
  final PublisherDatasource publisherDatasource;
  final AuthorRepository authorRepository;
  final String? bookId;
  BookDomain? book;

  // Form controllers
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();

  final Rx<BookContentRating> contentRating = BookContentRating.unrated.obs;
  final Rx<BookStatus> status = BookStatus.active.obs;
  final Rx<BookType> type = BookType.ebook.obs;

  Rx<Uint8List>? thumbnailBytes = Rx(Uint8List(0));

  // Media info
  final RxString fileFormat = ''.obs;
  final Rx<PlatformFile?> selectedFile = Rx(null);

  // Ebook
  final RxDouble fileSizeMb = 0.0.obs;

  // Audiobook
  final TextEditingController narratorNameController = TextEditingController();
  final TextEditingController bitRateController = TextEditingController();
  final TextEditingController sampleRateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  // Publishers - Authors - Categories - Tags
  final RxList<AuthorDomain> authors = <AuthorDomain>[].obs;
  RxBool isLoadingAuthors = false.obs;
  final RxList<CategoryDomain> categories = <CategoryDomain>[].obs;
  RxBool isLoadingCategories = false.obs;
  final RxList<PublisherModel> publishers = <PublisherModel>[].obs;
  RxBool isLoadingPublishers = false.obs;
  final RxList<TagDomain> tags = <TagDomain>[].obs;
  RxBool isLoadingTags = false.obs;
  final RxList<AuthorDomain> selectedAuthors = <AuthorDomain>[].obs;
  final RxList<CategoryDomain> selectedCategories = <CategoryDomain>[].obs;
  final RxList<TagDomain> selectedTags = <TagDomain>[].obs;
  Rx<PublisherModel?> publisher = Rx(null);

  @override
  void onReady() {
    super.onReady();
    // onReady is a good place for the initial load.
    // It ensures the controller is fully initialized.
    if (book != null) {
      _loadBookData(book!);
    }
  }

  /// This method is now the single source of truth for loading book data
  /// into the form. It can be called from the view when a new book is pushed
  /// onto an existing edit page.
  void _loadBookData(BookDomain book) {
    titleController.text = book.title ?? '';
    subtitleController.text = book.subtitle ?? '';
    isbnController.text = book.isbn ?? '';
    descriptionController.text = book.description ?? '';
    languageController.text = book.language ?? '';
    pageCountController.text = book.pageCount?.toString() ?? '';

    selectedTags.value = book.tags ?? [];
    selectedAuthors.value = book.authors ?? [];
    selectedCategories.value = book.categories ?? [];

    status.value = BookStatus.valueOf(book.status) ?? BookStatus.active;
    type.value = book.bookType;
    contentRating.value = BookContentRating.valueOf(book.contentRating) ??
        BookContentRating.unrated;

    if (book.bookType == BookType.audiobook) {
      narratorNameController.text =
          (book as AudiobookDomain).narratorName ?? '';

      bitRateController.text =
          (book).bitrate != null ? (book).bitrate.toString() : '';
      sampleRateController.text =
          (book).sampleRate != null ? (book).sampleRate.toString() : '';
      durationController.text = (book).totalDurationSeconds != null
          ? (book).totalDurationSeconds.toString()
          : '';
    }

    fileSizeMb.value = (book.bookType == BookType.ebook
            ? (book as EbookDomain).fileSizeMBytes
            : book.bookType == BookType.audiobook
                ? (book as AudiobookDomain).fileSizeMBytes
                : 0.0) ??
        0.0;

    // We need to update the local book reference as well
    this.book = book;
  }

  @override
  Future<void> onInit() async {
    await Future.wait([
      _fetchPublishers(),
      _fetchCategories(),
      _fetchAuthors(),
      _fetchTags(),
    ]);
    super.onInit();
  }

  Future<void> selectThumbnail() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      thumbnailBytes?.value = await pickedFile.readAsBytes();
      update();
    }
  }

  Future<void> selectFile(BuildContext context) async {
    final FilePickerResult? pickedFileResult =
        await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );

    if (pickedFileResult != null &&
        pickedFileResult.files.isNotEmpty &&
        pickedFileResult.files.first.bytes != null) {
      selectedFile.value = pickedFileResult.files.first;
      fileFormat.value = selectedFile.value?.extension ?? '';
      update();

      if (type.value != BookType.book) {
        final String fileSizeString =
            (selectedFile.value!.size / (1024 * 1024)).toStringAsFixed(2);
        fileSizeMb.value = double.parse(fileSizeString);
      }
    }
  }

  Future<void> createOrUpdateBook(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);

        final bool success = await bookRepository.createOrUpdateBook(
          libraryId: userController.library?.objectId ?? '',
          bookType: type.value,
          book: GeneralBookDomain(
            bookId: bookId,
            title: titleController.text.trim(),
            subtitle: subtitleController.text.trim(),
            isbn: isbnController.text.trim(),
            description: descriptionController.text.trim(),
            language: languageController.text.trim(),
            pageCount: int.tryParse(pageCountController.text.trim()) ?? 0,
            contentRating: contentRating.value.name,
            status: status.value.name,
          ),
          photoBytes: thumbnailBytes?.value,
          mediaBytes: selectedFile.value?.bytes,
          fileSizeMb: fileSizeMb.value,
          fileFormat: fileFormat.value,
          totalDurationSeconds: int.tryParse(bitRateController.text.trim()),
          bitrate: int.tryParse(sampleRateController.text.trim()),
          sampleRate: int.tryParse(durationController.text.trim()),
          narratorName: narratorNameController.text.trim(),
          authorIds: selectedAuthors.map((e) => e.id ?? '').toList(),
          categoriesIds: selectedCategories.map((e) => e.id).toList(),
          tagsIds: selectedTags.map((e) => e.id).toList(),
          publisherId: publisher.value?.objectId ?? '',
        );

        if (success && context.mounted) {
          LoadingOverlay.hide(context: context);

          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: bookId != null
                  ? 'app.editedBookSuccessfully'.tr
                  : 'app.createdBookSuccessfully'.tr,
            ),
          );

          goBack(context);
        }
      }
    } finally {
      if (context.mounted && LoadingOverlay.isShowing(context: context)) {
        LoadingOverlay.hide(context: context);
      }
    }
  }

  Future<void> _fetchTags() async {
    isLoadingTags.value = true;
    final result = await tagsDatasource.getAllTagsByLibrary(
      libraryId: userController.library?.objectId ?? '',
    );
    final List<TagDomain> tagDomains =
        result.map((t) => TagsMapper.tagToDomain(t)).toList();
    tags.assignAll(tagDomains);
    isLoadingTags.value = false;
  }

  Future<void> _fetchAuthors() async {
    isLoadingAuthors.value = true;
    final result = await authorRepository.getAllAuthors();
    authors.assignAll(result);
    isLoadingAuthors.value = false;
  }

  Future<void> _fetchPublishers() async {
    isLoadingPublishers.value = true;
    final result = await publisherDatasource.getAllPublishers();
    publishers.assignAll(result);
    publisher.value = publishers.first;
    isLoadingPublishers.value = false;
  }

  Future<void> _fetchCategories() async {
    isLoadingCategories.value = true;
    final result = await categoriesRepository.getAllCategories();
    categories.assignAll(result);
    isLoadingCategories.value = false;
  }

  void _resetFields() {
    book = null;
    bookId == null;
    titleController.clear();
    subtitleController.clear();
    isbnController.clear();
    descriptionController.clear();
    languageController.clear();
    pageCountController.clear();

    contentRating.value = BookContentRating.unrated;
    status.value = BookStatus.active;
    type.value = BookType.ebook;

    thumbnailBytes = Rx(Uint8List(0));
    fileFormat.value = '';
    fileSizeMb.value = 0.0;
    selectedFile.value = null;

    narratorNameController.clear();
    bitRateController.clear();
    sampleRateController.clear();
    durationController.clear();

    selectedAuthors.clear();
    selectedCategories.clear();
    selectedTags.clear();
    publisher.value = publishers.isNotEmpty ? publishers.first : null;
  }

  void goBack(BuildContext context) {
    _resetFields();
    NavigatorHelper.go(
      '/${Routes.books}',
      context: context,
    );
  }
}
