import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/product.dart';
import 'package:untitled3/domain/usecases/get_product_by_id.dart';
import 'package:untitled3/domain/usecases/get_products.dart';
import 'package:untitled3/domain/usecases/get_products_by_category.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;
  final GetProductById getProductById;

  ProductProvider({
    required this.getProducts,
    required this.getProductsByCategory,
    required this.getProductById,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Product> _products = [];
  List<Product> get products => _products;

  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String? _error;
  String? get error => _error;

  Future<void> fetchProducts() async {
    print("ProductProvider: Fetching products..."); // DEBUG PRINT
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await getProducts();
      print("ProductProvider: Fetched ${_products.length} products."); // DEBUG PRINT
    } catch (e) {
      _error = e.toString();
      print("ProductProvider: ERROR fetching products - $e"); // DEBUG PRINT
    } finally {
      _isLoading = false;
      notifyListeners();
      print("ProductProvider: fetchProducts finished."); // DEBUG PRINT
    }
  }

  Future<void> fetchProductById(String productId) async {
    _isLoading = true;
    _selectedProduct = null;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await getProductById(productId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _isSearching = query.isNotEmpty;
    if (!_isSearching) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = _products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
        
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    _isLoading = true;
    _error = null;
    _products = []; // Clear previous results
    notifyListeners();

    try {
      _products = await getProductsByCategory(categoryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
