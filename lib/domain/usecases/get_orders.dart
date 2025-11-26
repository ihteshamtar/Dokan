import 'package:untitled3/domain/entities/order.dart';
import 'package:untitled3/domain/repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<List<Order>> call() {
    return repository.getOrders();
  }
}
