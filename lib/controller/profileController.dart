import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/statusrequest.dart';

import 'package:medilink/core/class/crud.dart';
import 'package:medilink/models/profile_model.dart';

import '../data/datasourse/remot/ProfileDataSource.dart' show ProfileDataSource;

class ProfileController extends GetxController {
  final _box = GetStorage();
  final _dataSource = ProfileDataSource(Get.find<Crud>());
  var profileImageBytes = Rx<Uint8List?>(null);
  var profileImageLoading = false.obs;

  var status = StatusRequest.none.obs;
  var profile = Rxn<ProfileModel>();

  var name = ''.obs;
  var role = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var hospital = ''.obs;
  var centerId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    status.value = StatusRequest.loading;
    final res = await _dataSource.fetchProfile();
    res.fold((err) => status.value = err, (data) {
      profile.value = data;

      name.value = data.fullName;
      email.value = data.email;
      phone.value = data.phone;
      address.value = data.address ?? '';

      role.value = _mapRoleToArabic(data.role ?? '');
      centerId.value = data.centerId ?? 0;
      if (data.profilePhoto != null && data.profilePhoto!.isNotEmpty) {
        loadProfileImage(data.profilePhoto!);
      }

      status.value = StatusRequest.success;
    });
  }

  String _mapRoleToArabic(String role) {
    switch (role.toLowerCase()) {
      case 'secretary':
        return 'secretary';
      case 'center_manager':
        return 'center manager ';
      case 'admin':
        return ' admin';
      case 'ministry':
        return ' ministry';
      default:
        return role;
    }
  }

  Future<void> saveProfile() async {
    if (status.value == StatusRequest.loading) return;
    status.value = StatusRequest.loading;
    final res = await _dataSource.updateProfile(
      fullName: name.value,
      email: email.value,
      phone: phone.value,
      address: address.value,
    );
    res.fold((err) => status.value = err, (updated) {
      profile.value = updated;
      status.value = StatusRequest.success;
      Get.back();
    });
  }

  Future<void> changePhoto(dynamic fileSource) async {
    status.value = StatusRequest.loading;
    final res = await _dataSource.uploadPhoto(fileSource);
    res.fold((err) => status.value = err, (photoPath) {
      profile.value = profile.value?.copyWith(profilePhoto: photoPath);
      loadProfileImage(photoPath);
      status.value = StatusRequest.success;
    });
  }

  Future<void> loadProfileImage(String imagePath) async {
    try {
      profileImageLoading.value = true;
      final fullUrl = '${AppLink.serverimage}/$imagePath';
      final bytes = await Get.find<Crud>().getImageWithToken(fullUrl);
      profileImageBytes.value = bytes;
    } catch (e) {
      print("Failed to load profile image: $e");
      profileImageBytes.value = null;
    } finally {
      profileImageLoading.value = false;
    }
  }
}
