import 'package:book_store_admin/data/datasources/categories_datasource.dart';
import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/domain/mapper/categories_mapper.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';

class CategoriesRepository {
  CategoriesRepository({
    required this.categoriesDatasource,
  });

  final CategoriesDatasource categoriesDatasource;

  Future<List<CategoryDomain>> getAllCategories() async {
    final List<CategoryDomain> categories = [];

    final List<CategoryModel> categoriesModels =
        await categoriesDatasource.getAllCategories();

    for (final categoryModel in categoriesModels) {
      final CategoryDomain categoryDomain =
          CategoriesMapper.categoryToDomain(categoryModel);

      categories.add(categoryDomain);
    }

    categories.sort(
      (a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0),
    );

    return categories;
  }
}
