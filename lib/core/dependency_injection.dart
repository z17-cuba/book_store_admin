import 'package:book_store_admin/core/logger/logger_filter.dart';
import 'package:book_store_admin/data/datasources/author_datasource.dart';
import 'package:book_store_admin/data/datasources/checkout_datasource.dart';
import 'package:book_store_admin/data/datasources/library_datasource.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/data/datasources/local/local_storage_service.dart';
import 'package:book_store_admin/data/datasources/account_datasource.dart';
import 'package:book_store_admin/data/datasources/audiobooks_datasource.dart';
import 'package:book_store_admin/data/datasources/books_datasource.dart';
import 'package:book_store_admin/data/datasources/categories_datasource.dart';
import 'package:book_store_admin/data/datasources/ebooks_datasource.dart';
import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/data/datasources/reading_progress_datasource.dart';
import 'package:book_store_admin/data/datasources/tags_datasource.dart';
import 'package:book_store_admin/data/datasources/user_datasource.dart';
import 'package:book_store_admin/domain/repositories/author_repository.dart';
import 'package:book_store_admin/domain/repositories/book_repository.dart';
import 'package:book_store_admin/domain/repositories/categories_repository.dart';
import 'package:book_store_admin/domain/repositories/library_repository.dart';
import 'package:book_store_admin/env.dart';
import 'package:book_store_admin/presentation/controllers/language/language_controller.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  late String transfermovilPackageName;

  static Future<void> init() async {
    _setupLogger();

    await _setupCaches();

    await _initPackageInfo();

    await _setupProviders();

    await _setupRepositories();

    _setupControllers();
  }

  static void _setupLogger() {
    Get
      ..lazyPut(
        () => Logger(),
        fenix: true,
      )
      ..lazyPut<Logger>(
        () => Logger(
          printer: PrettyPrinter(methodCount: 0),
          filter: LoggerFilter(),
        ),
        fenix: true,
        tag: 'ControllerLogger',
      );
  }

  static Future<void> _setupCaches() async {
    //Vars
    final sharedPreferences = await SharedPreferences.getInstance();

    //Injections
    Get
      ..lazyPut<SharedPreferences>(
        () => sharedPreferences,
        fenix: true,
      )
      ..lazyPut<LocalStorageService>(
        () => LocalStorageService(
          preferences: Get.find<SharedPreferences>(),
        ),
        fenix: true,
      );
  }

  static Future<void> _setupProviders() async {
    // Parse initialize
    final Parse parse = await Parse().initialize(
      Env.appId,
      Env.serverUrl,
      clientKey: Env.clientKey,
      masterKey: Env.masterKey,
    );

    Get
      ..lazyPut<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
        fenix: true,
      )
      ..lazyPut<CredentialStorageDatasource>(
        () => CredentialStorageDatasource(
          logger: Get.find<Logger>(),
          storage: Get.find<FlutterSecureStorage>(),
        ),
        fenix: true,
      )
      ..lazyPut<UserDatasource>(
        () => UserDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<LibraryDatasource>(
        () => LibraryDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<TagsDatasource>(
        () => TagsDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<CheckoutDatasource>(
        () => CheckoutDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<ReadingProgressDatasource>(
        () => ReadingProgressDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<EbooksDatasource>(
        () => EbooksDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<AudiobooksDatasource>(
        () => AudiobooksDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<BooksDatasource>(
        () => BooksDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
          ebooksDatasource: Get.find<EbooksDatasource>(),
          audiobooksDatasource: Get.find<AudiobooksDatasource>(),
        ),
        fenix: true,
      )
      ..lazyPut<AuthorDatasource>(
        () => AuthorDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<CategoriesDatasource>(
        () => CategoriesDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<PublisherDatasource>(
        () => PublisherDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
        ),
        fenix: true,
      )
      ..lazyPut<AccountDatasource>(
        () => AccountDatasource(
          parse: parse,
          logger: Get.find<Logger>(),
          credentialStorageDatasource: Get.find<CredentialStorageDatasource>(),
        ),
        fenix: true,
      );
  }

  static Future<void> _setupRepositories() async {
    Get
      ..lazyPut<BookRepository>(
        () => BookRepository(
          booksDatasource: Get.find<BooksDatasource>(),
          ebooksDatasource: Get.find<EbooksDatasource>(),
          audiobooksDatasource: Get.find<AudiobooksDatasource>(),
          categoriesDatasource: Get.find<CategoriesDatasource>(),
        ),
        fenix: true,
      )
      ..lazyPut<CategoriesRepository>(
        () => CategoriesRepository(
          categoriesDatasource: Get.find<CategoriesDatasource>(),
        ),
        fenix: true,
      )
      ..lazyPut<AuthorRepository>(
        () => AuthorRepository(
          authorDatasource: Get.find<AuthorDatasource>(),
        ),
        fenix: true,
      )
      ..lazyPut<LibraryRepository>(
        () => LibraryRepository(
          bookRepository: Get.find<BookRepository>(),
          readingProgressDatasource: Get.find<ReadingProgressDatasource>(),
          checkoutDatasource: Get.find<CheckoutDatasource>(),
        ),
        fenix: true,
      );
  }

  static void _setupControllers() {
    Get
      ..put<LanguageController>(
        LanguageController(
          localStorageService: Get.find<LocalStorageService>(),
        ),
      )
      ..put<UserController>(
        UserController(
          localStorageService: Get.find<LocalStorageService>(),
          credentialStorageDatasource: Get.find<CredentialStorageDatasource>(),
          libraryDatasource: Get.find<LibraryDatasource>(),
          accountDatasource: Get.find<AccountDatasource>(),
        ),
      );
  }

  static Future<void> _initPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    Get.put<PackageInfo>(packageInfo, permanent: true);
  }
}
