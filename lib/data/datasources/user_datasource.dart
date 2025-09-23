import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserDatasource {
  UserDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<void> updateUser({
    required String userId,
    String? language,
    bool? setAdmin,
    // User Details
    String? email,
  }) async {
    try {
      email != null
          ? logger.i('Updating userId: $userId with email: $email')
          : logger.i(
              'Updating userId: $userId with language: $language or setAdmin privilege: $setAdmin');

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppUser),
      );

      parseQuery.whereEqualTo('objectId', userId);

      final apiResponse = await parseQuery.query();

      ParseObject userObject;

      if (apiResponse.success &&
          apiResponse.results != null &&
          apiResponse.results!.isNotEmpty) {
        // Update existing progress
        userObject = apiResponse.results!.first as ParseObject;

        if (language != null) {
          userObject.set('preferredLanguage', language);
        }

        if (setAdmin != null) {
          userObject.set('isAdmin', setAdmin);
        }

        if (email != null) {
          userObject.set('email', email);
        }

        final ParseResponse response = await userObject.save();

        if (!response.success) {
          logger.e('Error updating user: ${response.error}');
          throw CustomException(
              code: errorOnUserDatasource, errorMessage: 'Error updating user');
        }
      }
    } catch (e) {
      logger.e('Error on updateUser: $e');
      throw CustomException(
        code: errorOnUserDatasource,
        errorMessage: 'updateUser',
      );
    }
  }

  Future<String?> getLanguage({
    required String userId,
  }) async {
    try {
      logger.i('Getting language for userId: $userId');
      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppUser),
      );

      parseQuery.whereEqualTo('objectId', userId);

      final apiResponse = await parseQuery.query();

      ParseObject userObject;

      if (apiResponse.success &&
          apiResponse.results != null &&
          apiResponse.results!.isNotEmpty) {
        userObject = apiResponse.results!.first as ParseObject;
        return userObject.get('preferredLanguage');
      }

      return null;
    } catch (exception) {
      logger.e('Error on getLanguage: $exception');
      throw CustomException(
        code: errorOnUserDatasource,
        errorMessage: 'getLanguage',
      );
    }
  }
}
