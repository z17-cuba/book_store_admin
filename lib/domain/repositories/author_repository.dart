import 'package:book_store_admin/data/datasources/author_datasource.dart';
import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/domain/mapper/author_mapper.dart';
import 'package:book_store_admin/domain/models/author_domain.dart';

class AuthorRepository {
  AuthorRepository({
    required this.authorDatasource,
  });

  final AuthorDatasource authorDatasource;

  Future<List<AuthorDomain>> getAllAuthors() async {
    final List<AuthorDomain> authors = [];

    final List<AuthorModel> authorModels =
        await authorDatasource.getAllAuthors();

    for (final authorModel in authorModels) {
      final AuthorDomain authorDomain =
          AuthorMapper.authorToDomain(authorModel);
      authors.add(authorDomain);
    }

    authors.sort(
      (a, b) => (a.name ?? '').compareTo(b.name ?? ''),
    );

    return authors;
  }
}
