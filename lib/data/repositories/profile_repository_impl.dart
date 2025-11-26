import 'package:untitled3/data/datasources/api_datasource.dart';
import 'package:untitled3/domain/entities/profile.dart';
import 'package:untitled3/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiDataSource apiDataSource;

  ProfileRepositoryImpl({required this.apiDataSource});

  @override
  Future<Profile> getProfile() async {
    final profileModel = await apiDataSource.getProfile();
    // Convert ProfileModel to Profile entity
    return Profile(
      name: profileModel.name,
      email: profileModel.email,
      phone: profileModel.phone,
      avatarUrl: profileModel.avatarUrl,
    );
  }
}
