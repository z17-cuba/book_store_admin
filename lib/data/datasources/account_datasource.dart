import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/datasources/local/credential_storage_datasource.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccountDatasource {
  AccountDatasource({
    required this.parse,
    required this.logger,
    required this.credentialStorageDatasource,
  });

  final Parse parse;
  final Logger logger;
  final CredentialStorageDatasource credentialStorageDatasource;

  Future<bool?> signUp({
    required String username,
    required String password,
    String? email,
  }) async {
    logger.i(
        'Signing up with username: $username, email: $email and password: $password');
    final ParseUser parseUser = ParseUser.createUser(
      username,
      password,
      email,
    );

    final response = await parseUser.signUp();
    if (response.success) {
      return true;
    } else {
      logger.e('Error on signUp: ${response.error?.message}');
      throw CustomException(
        code: response.error?.type == 'EmailTaken'
            ? errorEmailAlreadyTaken
            : response.error?.type == 'UsernameTaken'
                ? errorUsernameAlreadyTaken
                : errorOnAccountDatasource,
        errorMessage: response.error?.message ?? 'app.unknownError'.tr,
      );
    }
  }

  Future<bool?> signIn({
    required String username,
    required String password,
    String? email,
  }) async {
    logger.i(
        'Signing in with username: $username and password: $password / email: $email');
    final ParseUser parseUser = ParseUser(
      username,
      password,
      email,
    );

    var response = await parseUser.login();

    if (response.success) {
      return true;
    } else {
      logger.e('Error on signIn: ${response.error?.message}');
      throw CustomException(
        code: response.error?.type == 'ObjectNotFound'
            ? errorInvalidCredentials
            : errorOnAccountDatasource,
        errorMessage: response.error?.message ?? 'app.unknownError'.tr,
      );
    }
  }

  Future<bool?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      logger.i('Changing password from: $oldPassword to: $newPassword');
      final ParseUser? currentUser = await ParseUser.currentUser();
      if (currentUser == null) {
        throw CustomException(
          code: errorOnAccountDatasource,
          errorMessage: 'User not logged in',
        );
      }

      // Re-authenticate user before changing password for security
      final ParseUser reAuthUser = ParseUser(
        currentUser.username,
        oldPassword,
        currentUser.emailAddress,
      );
      final reAuthResponse = await reAuthUser.login();

      if (reAuthResponse.success) {
        currentUser.password = newPassword;
        final updateResponse = await currentUser.update();
        return updateResponse.success;
      } else {
        logger.e(
            'Error on changePassword (re-authentication failed): ${reAuthResponse.error?.message}');
        throw CustomException(
          code: errorInvalidCredentials,
          errorMessage:
              reAuthResponse.error?.message ?? 'app.invalidCredentials'.tr,
        );
      }
    } catch (exception) {
      logger.e('Error on changePassword: $exception');
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      logger.i('Logging out');

      final String? username = await credentialStorageDatasource.getUsername();
      final String? password = await credentialStorageDatasource.getPassword();
      final String? email = await credentialStorageDatasource.getEmail();

      final ParseUser parseUser = ParseUser(
        username,
        password,
        email,
      );

      var response = await parseUser.logout();

      return response.success;
    } catch (exception) {
      logger.e('Error on logout: $exception');
      throw CustomException(
        code: errorOnAccountDatasource,
        errorMessage: exception.toString(),
      );
    }
  }
}
