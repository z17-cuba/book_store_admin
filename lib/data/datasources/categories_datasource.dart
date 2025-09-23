import 'package:book_store_admin/core/custom_exception.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CategoriesDatasource {
  CategoriesDatasource({
    required this.parse,
    required this.logger,
  });

  final Parse parse;
  final Logger logger;

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      logger.i('Geting all categories');

      final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject(back4AppCategories),
      )..whereEqualTo('isActive', true);

      final apiResponse = await parseQuery.query();

      if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results
                ?.map((cat) => CategoryModel.fromJson(cat.toJson()))
                .toList() ??
            [];
      }
      return [];
    } catch (exception) {
      logger.e('Error on getAllCategories: $exception');
      throw CustomException(
        code: errorOnCategoriesDatasource,
        errorMessage: 'getAllCategories',
      );
    }
  }
}
