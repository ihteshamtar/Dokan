import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/category.dart';
import 'package:untitled3/domain/usecases/get_categories.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategories getCategories;

  CategoryProvider({required this.getCategories});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  String? _error;
  String? get error => _error;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
