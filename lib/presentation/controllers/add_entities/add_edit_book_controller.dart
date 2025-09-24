import 'dart:typed_data';

import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/data/models/tags_model.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';
import 'package:book_store_admin/domain/models/book_domain.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';
import 'package:book_store_admin/domain/models/general_book_domain.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/domain/repositories/categories_repository.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/routes/navigator_helper.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
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
  RxInt totalDurationSeconds = 0.obs;
  RxInt bitrate = 0.obs;
  RxInt sampleRate = 0.obs;

  // Publishers - Authors - Categories - Tags
  final RxList<AuthorDomain> authors = <AuthorDomain>[].obs;
  RxBool isLoadingAuthors = false.obs;
  final RxList<CategoryDomain> categories = <CategoryDomain>[].obs;
  RxBool isLoadingCategories = false.obs;
  final RxList<PublisherModel> publishers = <PublisherModel>[].obs;
  RxBool isLoadingPublishers = false.obs;
  final RxList<TagsModel> tags = <TagsModel>[].obs;
  RxBool isLoadingTags = false.obs;
  final RxList<AuthorDomain> selectedAuthors = <AuthorDomain>[].obs;
  final RxList<CategoryDomain> selectedCategories = <CategoryDomain>[].obs;
  final RxList<TagsModel> selectedTags = <TagsModel>[].obs;
  Rx<PublisherModel?> publisher = Rx(null);

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

  Future<void> selectFile() async {
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

      // If it's an audiobook, try to extract metadata
      if (type.value == BookType.audiobook &&
          selectedFile.value?.path != null) {
        await _extractAudioMetadata(selectedFile.value!);
      } else if (type.value == BookType.ebook) {
        final String fileSizeString =
            (selectedFile.value!.size / (1024 * 1024)).toStringAsFixed(2);
        fileSizeMb.value = double.parse(fileSizeString);
      }
    }
  }

  Future<void> _extractAudioMetadata(PlatformFile selectedFile) async {
    // List of common audio extensions
    const audioExtensions = [
      'mp3',
      'wav',
      'm4a',
      'aac',
      'flac',
      'ogg',
      'opus',
    ];
    final fileExtension = selectedFile.extension?.toLowerCase() ?? '';

    if (audioExtensions.contains(fileExtension)) {
      LoadingOverlay.show();
      try {
        final session =
            await FFprobeKit.getMediaInformation(selectedFile.path ?? '');
        final information = session.getMediaInformation();

        if (information != null) {
          final durationString = information.getDuration();
          if (durationString != null) {
            totalDurationSeconds.value =
                (double.tryParse(durationString) ?? 0.0).round();
          }

          final streams = information.getStreams();
          if (streams.isNotEmpty) {
            final audioStream =
                streams.firstWhere((s) => s.getType() == 'audio');
            bitrate.value = int.tryParse(audioStream.getBitrate() ?? '0') ?? 0;
            sampleRate.value =
                int.tryParse(audioStream.getSampleRate() ?? '0') ?? 0;
          }
        }
      } finally {
        LoadingOverlay.hide();
      }
    }
  }

  Future<void> createBook(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);

        final bool success = await bookRepository.createBook(
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
            publicationDate: DateTime.now(),
          ),
          photoBytes: thumbnailBytes?.value,
          mediaBytes: selectedFile.value?.bytes,
          fileSizeMb: fileSizeMb.value,
          fileFormat: fileFormat.value,
          totalDurationSeconds: totalDurationSeconds.value,
          bitrate: bitrate.value,
          sampleRate: sampleRate.value,
          narratorName: narratorNameController.text.trim(),
          authorIds: selectedAuthors.map((e) => e.id).toList(),
          categoriesIds: selectedCategories.map((e) => e.id).toList(),
          tags: [],
          publisherId: publisher.value?.objectId ?? '',
        );

        // TODO publicationDate
        // TODO tags

        if (success && context.mounted) {
          LoadingOverlay.hide(context: context);

          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: 'app.createdBookSuccessfully'.tr,
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
    tags.assignAll(result);
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

  void goBack(BuildContext context) {
    titleController.clear();
    subtitleController.clear();
    isbnController.clear();
    descriptionController.clear();
    languageController.clear();
    pageCountController.clear();
    narratorNameController.clear();

    contentRating.value = BookContentRating.unrated;
    status.value = BookStatus.active;
    type.value = BookType.ebook;
    thumbnailBytes = Rx(Uint8List(0));
    fileFormat.value = '';
    fileSizeMb.value = 0.0;
    selectedFile.value = null;
    totalDurationSeconds.value = 0;
    bitrate.value = 0;
    sampleRate.value = 0;
    selectedAuthors.clear();
    selectedCategories.clear();

    NavigatorHelper.go(
      '/${Routes.books}',
      context: context,
    );
  }
}
