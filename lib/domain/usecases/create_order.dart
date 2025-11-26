import 'package:untitled3/domain/entities/order.dart';
import 'package:untitled3/domain/repositories/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Order> call(Map<String, dynamic> orderData) {
    return repository.createOrder(orderData);
  }
}
