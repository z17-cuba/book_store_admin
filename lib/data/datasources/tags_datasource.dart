import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/models/tags_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TagsDatasource {
  TagsDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  /// Fetches all tags associated with a specific library.
  Future<List<TagsModel>> getAllTagsByLibrary({
    int? skip,
    required String libraryId,
  }) async {
    try {
      logger.i('Getting all tags for library $libraryId - skipping $skip');
      final query = QueryBuilder<ParseObject>(ParseObject(back4AppTags))
        ..whereEqualTo(
          'library',
          (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer(),
        )
        ..setLimit(limitQueries);

      if (skip != null) {
        query.setAmountToSkip(skip);
      }

      final response = await query.query();

      if (response.success && response.results != null) {
        return response.results!
            .map((e) => TagsModel.fromJson(e.toJson()))
            .toList();
      }
      return [];
    } catch (e) {
      logger.e('Error on getAllTagsByLibrary: $e');
      throw CustomException(
        code: errorOnTagsDatasource,
        errorMessage: 'getAllTagsByLibrary',
      );
    }
  }

  /// Creates a new tag for a specific library.
  Future<bool> createTag({
    required String name,
    required String libraryId,
  }) async {
    try {
      logger.i('Creating tag "$name" for library $libraryId');
      final tagObject = ParseObject(back4AppTags)
        ..set('name', name)
        ..set('library',
            (ParseObject(back4AppLibraries)..objectId = libraryId).toPointer());

      final response = await tagObject.save();

      return response.success && response.result != null;
    } catch (e) {
      logger.e('Error on createTag: $e');
      throw CustomException(
        code: errorOnTagsDatasource,
        errorMessage: 'createTag',
      );
    }
  }

  /// Updates an existing tag's name.
  Future<bool> updateTag({
    required String tagId,
    required String newName,
  }) async {
    try {
      logger.i('Updating tag $tagId to name "$newName"');
      final tagObject = ParseObject(back4AppTags)
        ..objectId = tagId
        ..set('name', newName);

      final response = await tagObject.save();
      return response.success;
    } catch (e) {
      logger.e('Error on updateTag: $e');
      throw CustomException(
        code: errorOnTagsDatasource,
        errorMessage: 'updateTag',
      );
    }
  }

  /// Deletes a tag by its ID.
  Future<bool> deleteTag({
    required String tagId,
  }) async {
    try {
      logger.i('Deleting tag $tagId');
      final tagObject = ParseObject(back4AppTags)..objectId = tagId;
      final response = await tagObject.delete();
      return response.success;
    } catch (e) {
      logger.e('Error on deleteTag: $e');
      throw CustomException(
        code: errorOnTagsDatasource,
        errorMessage: 'deleteTag',
      );
    }
  }
}
