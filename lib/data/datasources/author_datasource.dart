import 'dart:typed_data';

import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthorDatasource {
  AuthorDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<bool> createAuthor({
    required AuthorModel authorModel,
    required String libraryId,
    Uint8List? photoBytes,
  }) async {
    try {
      logger.i('Creating new authorModel ${authorModel.toString()}');

      ParseFileBase parseFile;

      final ParseObject authorModelObject = ParseObject(back4AppAuthors)
        ..set('firstName', authorModel.firstName)
        ..set('lastName', authorModel.lastName)
        ..set('bio', authorModel.bio)
        ..set('nationality', authorModel.nationality)
        ..set('birthDate', authorModel.birthDate)
        ..set('websiteUrl', authorModel.websiteUrl)
        ..set(
          'library',
          (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
        );

      if (photoBytes != null && photoBytes.isNotEmpty) {
        parseFile = ParseWebFile(
          photoBytes,
          name:
              'Author_${authorModel.firstName?.removeAllWhitespace ?? ''}_${authorModel.lastName?.removeAllWhitespace ?? ''}_photo',
        );

        authorModelObject.set("photo", parseFile);
      }

      final ParseResponse apiResponse = await authorModelObject.save();

      if (apiResponse.success) {
        logger.i(
            'Author created successfully with ID: ${authorModelObject.objectId}');

        return true;
      } else {
        logger.e('Failed to create author: ${apiResponse.error}');
        return false;
      }
    } catch (exception) {
      logger.e('Error on createAuthor: $exception');
      throw CustomException(
        code: errorOnAuthorDatasource,
        errorMessage: 'createAuthor',
      );
    }
  }

  Future<bool> updateAuthor({
    required AuthorModel authorModel,
    required String libraryId,
    Uint8List? photoBytes,
  }) async {
    try {
      logger.i('Updating new authorModel ${authorModel.toString()}');

      ParseFileBase parseFile;

      final ParseObject authorModelObject = ParseObject(back4AppAuthors)
        ..objectId = authorModel.objectId
        ..set('firstName', authorModel.firstName)
        ..set('lastName', authorModel.lastName)
        ..set('bio', authorModel.bio)
        ..set('nationality', authorModel.nationality)
        ..set('birthDate', authorModel.birthDate)
        ..set('websiteUrl', authorModel.websiteUrl)
        ..set(
          'library',
          (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
        );

      if (photoBytes != null && photoBytes.isNotEmpty) {
        parseFile = ParseWebFile(
          photoBytes,
          name:
              'Author_${authorModel.firstName?.removeAllWhitespace ?? ''}_${authorModel.lastName?.removeAllWhitespace ?? ''}_photo',
        );

        authorModelObject.set("photo", parseFile);
      }

      final ParseResponse apiResponse = await authorModelObject.save();

      if (apiResponse.success) {
        logger
            .i('Author updated successfully with ID: ${authorModel.objectId}');

        return true;
      } else {
        logger.e('Failed to update author: ${apiResponse.error}');
        return false;
      }
    } catch (exception) {
      logger.e('Error on updateAuthor: $exception');
      throw CustomException(
        code: errorOnAuthorDatasource,
        errorMessage: 'updateAuthor',
      );
    }
  }

  Future<List<AuthorModel>> getAllAuthors() async {
    try {
      logger.i('Getting all authors');

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppAuthors),
      );

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results!
            .map((author) => AuthorModel.fromJson(author.toJson()))
            .toList();
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllAuthors: $exception');
      throw CustomException(
        code: errorOnAuthorDatasource,
        errorMessage: 'getAllAuthors',
      );
    }
  }

  Future<List<AuthorModel>> getAllAuthorsByLibrary({
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger.i('Getting all authors for library $libraryId - skipping $skip');

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppAuthors),
      )
        ..whereEqualTo(
          'library',
          (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
        )
        ..setLimit(limitQueries);

      if (skip != null) {
        parseQuery.setAmountToSkip(skip);
      }

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results!
            .map((author) => AuthorModel.fromJson(author.toJson()))
            .toList();
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllAuthorsByLibrary: $exception');
      throw CustomException(
        code: errorOnAuthorDatasource,
        errorMessage: 'getAllAuthorsByLibrary',
      );
    }
  }

  /// Deletes an author by its ID.
  Future<bool> deleteAuthor({
    required String authorId,
  }) async {
    try {
      logger.i('Deleting author $authorId');
      final tagObject = ParseObject(back4AppAuthors)..objectId = authorId;
      final response = await tagObject.delete();
      return response.success;
    } catch (e) {
      logger.e('Error on deleteAuthor: $e');
      throw CustomException(
        code: errorOnAuthorDatasource,
        errorMessage: 'deleteAuthor',
      );
    }
  }
}
