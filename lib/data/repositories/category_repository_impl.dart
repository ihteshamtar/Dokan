import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/category.dart';
import 'package:untitled3/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiDataSource apiDataSource;

  CategoryRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Category>> getCategories() async {
    final categoryModels = await apiDataSource.getCategories();
    return categoryModels
        .map((model) => Category(
              id: model.id,
              name: model.name,
              image: model.image,
            ))
        .toList();
  }
}
