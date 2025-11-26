import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String categoryId) {
    return repository.getProductsByCategory(categoryId);
  }
}
