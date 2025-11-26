import 'package:untitled3/domain/entities/order_item.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
  });
}
