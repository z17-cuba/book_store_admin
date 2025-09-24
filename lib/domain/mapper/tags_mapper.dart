import 'package:book_store_admin/data/models/tag_model.dart';
import 'package:book_store_admin/domain/models/tag_domain.dart';

class TagsMapper {
  static TagDomain tagToDomain(
    TagModel tag,
  ) {
    return TagDomain(
      id: tag.objectId ?? '',
      name: tag.name,
    );
  }
}
