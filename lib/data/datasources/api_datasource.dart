import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled3/data/models/banner_model.dart';
import 'package:untitled3/data/models/cart_item_model.dart';
import 'package:untitled3/data/models/category_model.dart';
import 'package:untitled3/data/models/order_model.dart';
import 'package:untitled3/data/models/product_model.dart';
import 'package:untitled3/data/models/profile_model.dart';

class ApiDataSource {
  final String _baseUrl = 'https://karyana-apis-backend.vercel.app/api';
  String _token = '';

  void setToken(String token) {
    _token = token;
  }

  // Helper method for robust error handling
  Exception _handleError(http.Response response) {
    print('API Error Response Code: ${response.statusCode}');
    print('API Error Response Body: ${response.body}');
    try {
      final errorData = json.decode(response.body) as Map<String, dynamic>;
      final message = errorData['message'] ?? 'An unknown API error occurred.';
      return Exception(message);
    } catch (_) {
      if (response.body.isNotEmpty) {
        return Exception('Server returned an invalid response. See console for details.');
      }
      return Exception('An unknown server error occurred. Status code: ${response.statusCode}');
    }
  }

  bool _isValidObjectId(dynamic id) {
    if (id is! String) return false;
    // A valid MongoDB ObjectId is a 24-character hex string.
    return RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id);
  }

  Future<List<BannerModel>> getBanners() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/banners/'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['banners'];
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/all'),
      headers: {'Authorization': 'Bearer $_token'}, 
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      // FIX: Filter out products with invalid MongoDB ObjectId formats
      final filteredData = data.where((productJson) {
        final id = productJson['_id'] ?? productJson['id'];
        return _isValidObjectId(id);
      }).toList();
      return filteredData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/get/$productId'),
      headers: {'Authorization': 'Bearer $_token'}, 
    );
    
    print('GetProductById Response: ${response.body}');

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body)['product']);
    } else {
      throw _handleError(response);
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$categoryId'),
      headers: {'Authorization': 'Bearer $_token'}, 
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      // FIX: Filter out products with invalid MongoDB ObjectId formats
      final filteredData = data.where((productJson) {
        final id = productJson['_id'] ?? productJson['id'];
        return _isValidObjectId(id);
      }).toList();
      return filteredData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<ProfileModel> getProfile() async {
    final response = await http.get(Uri.parse('$_baseUrl/users/profile'), headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw _handleError(response);
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'] as String;
      setToken(token);
      return token;
    } else {
      throw _handleError(response);
    }
  }

  Future<void> register(String name, String email, String password, String phoneNumber, String shopName, String shopAddress) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'shopName': shopName,
        'shopAddress': shopAddress,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw _handleError(response);
    }
  }

   Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categories/all'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['categories'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<List<CartItemModel>> getCartItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/cart/get'), headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['cart']['items'];
      return data.map((json) => CartItemModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cart/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, dynamic>{'productId': productId, 'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw _handleError(response);
    }
  }

  Future<void> updateCartItem(String productId, int quantity) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/cart/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, dynamic>{'itemId': productId, 'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw _handleError(response);
    }
  }

  Future<void> removeFromCart(String productId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cart/remove/$productId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode != 200) {
      throw _handleError(response);
    }
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/orders/'), headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['orders'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw _handleError(response);
    }
  }

  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/orders/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 201) {
      return OrderModel.fromJson(json.decode(response.body)['order']);
    } else {
      throw _handleError(response);
    }
  }
}
