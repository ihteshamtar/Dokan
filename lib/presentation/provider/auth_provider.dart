import 'package:flutter/material.dart';
import 'package:untitled3/domain/usecases/login.dart';
import 'package:untitled3/domain/usecases/register.dart';

class AuthProvider extends ChangeNotifier {
  final Login loginUseCase;
  final Register registerUseCase;

  AuthProvider({required this.loginUseCase, required this.registerUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await loginUseCase(email, password);
      // In a real app, you would save this token securely.
      print('Logged in with token: $token');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, s) { // Added stack trace
      print('Login Error: $e');
      print('Stack Trace: $s');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String phoneNumber, String shopName, String shopAddress) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await registerUseCase(name, email, password, phoneNumber, shopName, shopAddress);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, s) { // Added stack trace
      // This will print the exact error to your console.
      print('Registration Error: $e');
      print('Stack Trace: $s');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
