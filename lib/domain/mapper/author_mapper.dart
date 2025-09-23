import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';

class AuthorMapper {
  static AuthorDomain authorToDomain(
    AuthorModel authorModel,
  ) {
    return AuthorDomain(
      id: authorModel.objectId ?? '',
      name: '${authorModel.firstName} ${authorModel.lastName}',
      description: authorModel.bio,
      photoUrl: authorModel.photoUrl,
    );
  }
}
