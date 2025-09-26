import 'dart:typed_data';

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

    return authors;
  }

  Future<List<AuthorDomain>> getAllAuthorsByLibrary({
    int? skip,
    required String libraryId,
  }) async {
    final List<AuthorDomain> authors = [];

    final List<AuthorModel> authorModels =
        await authorDatasource.getAllAuthorsByLibrary(
      skip: skip,
      libraryId: libraryId,
    );

    for (final authorModel in authorModels) {
      final AuthorDomain authorDomain =
          AuthorMapper.authorToDomain(authorModel);
      authors.add(authorDomain);
    }

    return authors;
  }

  Future<bool> createAuthor({
    required AuthorDomain authorDomain,
    required String libraryId,
    Uint8List? photoBytes,
  }) async {
    final AuthorModel authorModel = AuthorMapper.authorToModel(authorDomain);

    return await authorDatasource.createAuthor(
      authorModel: authorModel,
      libraryId: libraryId,
      photoBytes: photoBytes,
    );
  }

  Future<bool> updateAuthor({
    required AuthorDomain authorDomain,
    required String libraryId,
    Uint8List? photoBytes,
  }) async {
    final AuthorModel authorModel = AuthorMapper.authorToModel(authorDomain);

    return await authorDatasource.updateAuthor(
      authorModel: authorModel,
      libraryId: libraryId,
      photoBytes: photoBytes,
    );
  }

  Future<bool> deleteAuthor({
    required String authorId,
  }) async {
    return await authorDatasource.deleteAuthor(
      authorId: authorId,
    );
  }
}
