import 'dart:io';
abstract class ProfileRepository {
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  });
}