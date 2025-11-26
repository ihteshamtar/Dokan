import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/banner.dart';
import 'package:untitled3/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final ApiDataSource apiDataSource;

  BannerRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Banner>> getBanners() async {
    final bannerModels = await apiDataSource.getBanners();
    return bannerModels
        .map((model) => Banner(id: model.id, imageUrl: model.imageUrl))
        .toList();
  }
}
