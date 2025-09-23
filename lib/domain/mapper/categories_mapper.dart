import 'package:book_store_admin/data/models/category_model.dart';
import 'package:book_store_admin/domain/models/category_domain.dart';

class CategoriesMapper {
  static CategoryDomain categoryToDomain(
    CategoryModel category,
  ) {
    return CategoryDomain(
      id: category.objectId ?? '',
      name: category.name,
      description: category.description,
      parentCategoryId: category.parentCategoryId,
      displayOrder: category.displayOrder,
    );
  }
}
