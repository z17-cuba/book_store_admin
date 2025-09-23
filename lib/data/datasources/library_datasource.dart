import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/core/enums.dart';
import 'package:book_store_admin/data/models/library_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LibraryDatasource {
  LibraryDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<bool> createLibrary({
    required LibraryModel library,
    required String userId,
  }) async {
    try {
      logger.i('Creating new library ${library.toString()} for user: $userId');

      final ParseObject libraryObject = ParseObject(back4AppLibraries)
        ..set('userId', ParseUser.forQuery()..objectId = userId)
        ..set('city', library.city)
        ..set('address', library.address)
        ..set('state', library.state)
        ..set('country', library.country)
        ..set('zipCode', library.zipCode)
        ..set('name', library.name)
        ..set('phone', library.phone)
        ..set('email', library.email)
        ..set('websiteUrl', library.websiteUrl)
        ..set('status', LibraryStatus.active.name);

      final ParseResponse apiResponse = await libraryObject.save();

      if (apiResponse.success) {
        logger.i(
            'Library created successfully with ID: ${libraryObject.objectId}');

        return true;
      } else {
        logger.e('Failed to create library: ${apiResponse.error}');
        return false;
      }
    } catch (exception) {
      logger.e('Error on createLibrary: $exception');
      throw CustomException(
        code: errorOnLibraryDatasource,
        errorMessage: 'createLibrary',
      );
    }
  }

  Future<bool> updateLibrary({
    required LibraryModel library,
  }) async {
    try {
      logger.i('Updating library ${library.toString()}');

      final ParseObject libraryObject = ParseObject(back4AppLibraries)
        ..objectId = library.objectId
        ..set('city', library.city)
        ..set('address', library.address)
        ..set('state', library.state)
        ..set('country', library.country)
        ..set('zipCode', library.zipCode)
        ..set('name', library.name)
        ..set('phone', library.phone)
        ..set('email', library.email)
        ..set('websiteUrl', library.websiteUrl)
        ..set('status', library.status);

      final ParseResponse apiResponse = await libraryObject.save();

      if (apiResponse.success) {
        logger.i(
            'Library updated successfully with ID: ${libraryObject.objectId}');

        return true;
      } else {
        logger.e('Failed to update library: ${apiResponse.error}');
        return false;
      }
    } catch (exception) {
      logger.e('Error on updateLibrary: $exception');
      throw CustomException(
        code: errorOnLibraryDatasource,
        errorMessage: 'updateLibrary',
      );
    }
  }

  Future<LibraryModel?> getibrary({
    required String userId,
  }) async {
    try {
      logger.i('Geting library from user $userId');

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppLibraries),
      );

      // Query by user pointer
      parseQuery.whereEqualTo(
        'userId',
        ParseObject(back4AppUser)..objectId = userId,
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        return LibraryModel.fromJson(
          apiResponse.results?.first.toJson(),
        );
      } else {
        return null;
      }
    } catch (exception) {
      logger.e('Error on getibrary: $exception');
      throw CustomException(
        code: errorOnLibraryDatasource,
        errorMessage: 'getibrary',
      );
    }
  }
}
