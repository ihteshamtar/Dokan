import 'package:flutter/material.dart';
import 'package:untitled3/domain/entities/banner.dart' as banner_entity;
import 'package:untitled3/domain/usecases/get_banners.dart';

class BannerProvider extends ChangeNotifier {
  final GetBanners getBanners;

  BannerProvider({required this.getBanners});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<banner_entity.Banner> _banners = [];
  List<banner_entity.Banner> get banners => _banners;

  String? _error;
  String? get error => _error;

  Future<void> fetchBanners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _banners = await getBanners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
