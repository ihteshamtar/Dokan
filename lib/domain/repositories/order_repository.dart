import 'package:untitled3/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> createOrder(Map<String, dynamic> orderData);
}
