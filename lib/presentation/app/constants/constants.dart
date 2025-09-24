import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//#region Dimensions
const double pagePaddingHorizontal = 15.0;

const double roundCornerRadius = 12.0;

const double separatedPadding = 10.0;

const double iconSize = 24.0;

const none = 0.0;
const nano = 2.0;
const micro = 4.0;
const xxs = 8.0;
const xxsPlus = 12.0;
const xs = 16.0;
const sm = 24.0;
const md = 32.0;
const lg = 40.0;
const xl = 48.0;
const xxl = 56.0;
const xxxl = 64.0;

const double smallFontSize = normalFontSize - 2.0;
const double normalFontSize = 14.0;
const double bigFontSize = normalFontSize + 2.0;
const double hugeFontSize = bigFontSize + 2.0;
const double enourmousFontSize = 20;
const double godzillaFontSize = 30;
const double cthulhuFontSize = 36;

double bigButtonSizeHeight = 0.1.sh;
double normalButtonSizeHeight = 0.09.sh;
double smallButtonSizeHeight = 0.06.sh;

//#region Language
const List<String> supportedLanguages = [
  'es',
  'en',
];
const List<String> supportedCountries = [
  'ES',
  'US',
];
const Map<String, String> supportedLocales = {
  'es': 'ES',
  'en': 'US',
};
const String defaultLanguage = 'es';
const String defaultCountry = 'ES';
const String defaultUserLocale = 'es_ES';

const String nameWebPanel = "Administración IslaLectura";

//#region Shared Preferences
const String sharedPrefAccessToken = 'access_token';
const String sharedPrefRefreshToken = 'refresh_token';
const String sharedPrefLanguage = 'language';
const String sharedPrefCountry = 'country';
const String sharedPrefTheme = 'theme';

//#region Parse
const int limitQueries = 10;

//#region Back4App Classes
const String back4AppUser = '_User';
const String back4AppAudiobookChapters = 'AudiobookChapters';
const String back4AppAudiobooks = 'Audiobooks';
const String back4AppAuthors = 'Authors';
const String back4AppBookPricing = 'BookPricing';
const String back4AppBooks = 'Books';
const String back4AppCategories = 'Categories';
const String back4AppEbooks = 'Ebooks';
const String back4AppLibraries = 'Libraries';
const String back4AppLibraryAnalytics = 'LibraryAnalytics';
const String back4AppLibraryContentLicenses = 'LibraryContentLicenses';
const String back4AppLibraryUsers = 'LibraryUsers';
const String back4AppPricingTiers = 'PricingTiers';
const String back4AppPublishers = 'Publishers';
const String back4AppReadingProgress = 'ReadingProgress';
const String back4AppUserCheckouts = 'UserCheckouts';
const String back4AppReviews = 'Reviews';
const String back4AppTags = 'Tags';

//#region Error Codes
const int sharedPrefErrorCode = 100;
const int errorOnCategoriesDatasource = 101;
const int errorOnBooksDatasource = 102;
const int errorOnEbooksDatasource = 103;
const int errorOnAudiobooksDatasource = 104;
const int errorOnAccountDatasource = 105;
const int errorEmailAlreadyTaken = 106;
const int errorUsernameAlreadyTaken = 107;
const int errorInvalidCredentials = 108;
const int errorOnCheckoutDatasource = 109;
const int errorOnLibraryDatasource = 110;
const int errorOnUserPreferencesDatasource = 111;
const int errorOnReadingProgressDatasource = 112;
const int errorOnUserDatasource = 113;
const int errorOnPublisherDatasource = 114;
const int errorOnAuthorDatasource = 115;
const int errorOnTagsDatasource = 116;
const int secureStorageErrorCode = 140;
