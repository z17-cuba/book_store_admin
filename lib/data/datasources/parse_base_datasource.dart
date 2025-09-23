import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseBaseDatasource {
  static Future<List<ParseObject>> getRelationObjects(
    ParseObject parseObject,
    String relationKey,
  ) async {
    try {
      final relation = parseObject.getRelation(relationKey);
      final query = relation.getQuery();
      final response = await query.query();
      return response.success
          ? response.results?.cast<ParseObject>() ?? []
          : [];
    } catch (e) {
      return [];
    }
  }
}
