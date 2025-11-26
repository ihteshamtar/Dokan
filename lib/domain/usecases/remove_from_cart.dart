import 'package:untitled3/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<void> call(String productId) {
    return repository.removeFromCart(productId);
  }
}
