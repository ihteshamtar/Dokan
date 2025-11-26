import 'package:untitled3/domain/entities/banner.dart';
import 'package:untitled3/domain/repositories/banner_repository.dart';

class GetBanners {
  final BannerRepository repository;

  GetBanners(this.repository);

  Future<List<Banner>> call() async {
    return await repository.getBanners();
  }
}
