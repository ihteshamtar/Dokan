import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Product> call(String productId) async {
    return await repository.getProductById(productId);
  }
}
