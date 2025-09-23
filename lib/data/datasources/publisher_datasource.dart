import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class PublisherDatasource {
  PublisherDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<bool> createPublisher({
    required PublisherModel publisher,
  }) async {
    try {
      logger.i('Creating new publisher ${publisher.toString()}');

      final ParseObject publisherObject = ParseObject(back4AppPublishers)
        ..set('address', publisher.address)
        ..set('name', publisher.name)
        ..set('phone', publisher.phone)
        ..set('contactEmail', publisher.email)
        ..set('websiteUrl', publisher.websiteUrl);

      final ParseResponse apiResponse = await publisherObject.save();

      if (apiResponse.success) {
        logger.i(
            'Publisher created successfully with ID: ${publisherObject.objectId}');

        return true;
      } else {
        logger.e('Failed to create publisher: ${apiResponse.error}');
        return false;
      }
    } catch (exception) {
      logger.e('Error on createPublisher: $exception');
      throw CustomException(
        code: errorOnPublisherDatasource,
        errorMessage: 'createPublisher',
      );
    }
  }

  Future<List<PublisherModel>> getAllPublishers() async {
    try {
      logger.i('Getting all publishers');

      final QueryBuilder<ParseObject> parseQuery =
          QueryBuilder<ParseObject>(ParseObject(back4AppPublishers));

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results!
            .map((publisher) => PublisherModel.fromJson(publisher.toJson()))
            .toList();
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllPublishers: $exception');
      throw CustomException(
        code: errorOnPublisherDatasource,
        errorMessage: 'getAllPublishers',
      );
    }
  }
}
