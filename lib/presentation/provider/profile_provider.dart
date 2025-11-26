import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/profile.dart';
import 'package:untitled3/domain/usecases/get_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfile getProfile;

  ProfileProvider({required this.getProfile});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Profile? _profile;
  Profile? get profile => _profile;

  String? _error;
  String? get error => _error;

  Future<void> fetchProfile() async {
    print("ProfileProvider: Fetching profile..."); // DEBUG PRINT
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await getProfile();
      print("ProfileProvider: Profile fetched successfully."); // DEBUG PRINT
    } catch (e) {
      _error = e.toString();
      print("ProfileProvider: ERROR fetching profile - $e"); // DEBUG PRINT
    } finally {
      _isLoading = false;
      notifyListeners();
      print("ProfileProvider: fetchProfile finished."); // DEBUG PRINT
    }
  }
}
