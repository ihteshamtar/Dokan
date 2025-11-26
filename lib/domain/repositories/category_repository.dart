import 'package:untitled3/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
