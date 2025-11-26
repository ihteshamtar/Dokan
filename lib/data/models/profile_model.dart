import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // This is the fix: Check for the 'user' key in the response.
    final userData = json.containsKey('user') && json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json; // Fallback to the root map if 'user' key doesn't exist.

    return ProfileModel(
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phoneNumber'] ?? '', // API might use 'phoneNumber'
      avatarUrl: userData['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }
}
