import 'package:book_store_admin/data/models/author_model.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseBookModel {
  ParseBookModel({
    required this.book,
    required this.tags,
    required this.categories,
    required this.authors,
  });

  ParseObject book;
  final List<ParseObject>? tags;
  final List<CategoryModel>? categories;
  final List<AuthorModel>? authors;
}
