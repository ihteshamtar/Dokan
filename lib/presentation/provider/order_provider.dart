import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/order.dart';
import 'package:untitled3/domain/usecases/create_order.dart';
import 'package:untitled3/domain/usecases/get_orders.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrders getOrders;
  final CreateOrder createOrder;

  OrderProvider({required this.getOrders, required this.createOrder});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  String? _error;
  String? get error => _error;

  Future<void> fetchOrders() async {
    print("OrderProvider: Fetching orders..."); // DEBUG PRINT
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await getOrders();
      print("OrderProvider: Fetched ${_orders.length} orders."); // DEBUG PRINT
    } catch (e) {
      _error = e.toString();
      print("OrderProvider: ERROR fetching orders - $e"); // DEBUG PRINT
    } finally {
      _isLoading = false;
      notifyListeners();
      print("OrderProvider: fetchOrders finished."); // DEBUG PRINT
    }
  }

  Future<Order?> placeOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newOrder = await createOrder(orderData);
      await fetchOrders(); // Refresh the list of orders

      _isLoading = false;
      notifyListeners();
      return newOrder; // Return the newly created order
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
