import 'package:untitled3/domain/entities/banner.dart';

abstract class BannerRepository {
  Future<List<Banner>> getBanners();
}
