import 'package:untitled3/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<void> call(String productId, int quantity) {
    return repository.addToCart(productId, quantity);
  }
}
