import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/models/local/credential.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class CredentialStorageDatasource {
  CredentialStorageDatasource({
    required this.storage,
    required this.logger,
  });

  final FlutterSecureStorage storage;
  final Logger logger;
  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyEmail = 'email';

  Future<Credential?> getCredential() async {
    try {
      final username = await storage.read(key: keyUsername);
      final password = await storage.read(key: keyPassword);
      final email = await storage.read(key: keyEmail);
      if (username != null && password != null) {
        return Credential(
          username: username,
          password: password,
          email: email,
        );
      }
      return null;
    } on Exception {
      logger.e('Error in secure storage / getCredential');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / getCredential',
      );
    }
  }

  Future<void> storageCredential({
    required String username,
    required String password,
    String? email,
  }) async {
    try {
      ///varios await seguidos no funcionan bien, por eso se meten mejor en el
      ///wait que termina cuando terminen todos
      await Future.wait(
        [
          storage.write(key: keyUsername, value: username),
          storage.write(key: keyPassword, value: password),
        ],
      );

      if (email != null) {
        await storage.write(key: keyEmail, value: email);
      }
    } on Exception {
      logger.e('Error in secure storage / storageCredential');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / storageCredential',
      );
    }
  }

  Future<void> clearCredential() async {
    try {
      ///varios await seguidos no funcionan bien, por eso se meten mejor en el
      ///wait que termina cuando terminen todos
      await Future.wait(
        [
          storage.delete(key: keyUsername),
          storage.delete(key: keyPassword),
          storage.delete(key: keyEmail),
        ],
      );
    } on Exception {
      logger.e('Error in secure storage / clearCredential');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / clearCredential',
      );
    }
  }

  Future<String?> getUsername() async {
    try {
      return await storage.read(key: keyUsername);
    } on Exception {
      logger.e('Error in secure storage / getUsername');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / getUsername',
      );
    }
  }

  Future<String?> getEmail() async {
    try {
      return await storage.read(key: keyEmail);
    } on Exception {
      logger.e('Error in secure storage / getEmail');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / getEmail',
      );
    }
  }

  Future<String?> getPassword() async {
    try {
      return await storage.read(key: keyPassword);
    } on Exception {
      logger.e('Error in secure storage / getPassword');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / getPassword',
      );
    }
  }

  Future<void> setUsername({
    required String username,
  }) async {
    try {
      await storage.write(key: keyUsername, value: username);
    } on Exception {
      logger.e('Error in secure storage / setUsername');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / setUsername',
      );
    }
  }

  Future<void> setEmail({
    required String email,
  }) async {
    try {
      await storage.write(key: keyEmail, value: email);
    } on Exception {
      logger.e('Error in secure storage / setEmail');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / setEmail',
      );
    }
  }

  Future<void> setPassword({
    required String password,
  }) async {
    try {
      await storage.write(key: keyPassword, value: password);
    } on Exception {
      logger.e('Error in secure storage / setPassword');
      throw CustomException(
        code: secureStorageErrorCode,
        errorMessage: 'Error in secure storage / setPassword',
      );
    }
  }
}
