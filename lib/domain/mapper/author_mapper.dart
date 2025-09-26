import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';

class AuthorMapper {
  static AuthorDomain authorToDomain(
    AuthorModel authorModel,
  ) {
    return AuthorDomain(
      id: authorModel.objectId ?? '',
      firstName: authorModel.firstName,
      lastName: authorModel.lastName,
      description: authorModel.bio,
      photoUrl: authorModel.photoUrl,
      nationality: authorModel.nationality,
      websiteUrl: authorModel.websiteUrl,
      birthDate: authorModel.birthDate,
    );
  }

  static AuthorModel authorToModel(
    AuthorDomain authorDomain,
  ) {
    return AuthorModel(
      objectId: authorDomain.id,
      firstName: authorDomain.firstName,
      lastName: authorDomain.lastName,
      bio: authorDomain.description,
      photoUrl: authorDomain.photoUrl,
      nationality: authorDomain.nationality,
      websiteUrl: authorDomain.websiteUrl,
      birthDate: authorDomain.birthDate,
    );
  }
}
