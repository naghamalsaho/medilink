import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import '../models/profile-model.dart';
import '../api_link.dart';
class UserController extends GetxController {
  final box = GetStorage();
Uint8List? tempImageBytes;
String? tempImagePath;

  var userName = ''.obs;
  var userRole = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userAddress = ''.obs;
  var userHospital = ''.obs;
  var userResponsibilities = ''.obs;
  var profileImagePath = ''.obs;
  var profileImageBytes = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();
    // استعادة البيانات
    userName.value           = box.read('userName') ?? '';
    userRole.value           = box.read('userRole') ?? '';
    userEmail.value          = box.read('userEmail') ?? '';
    userPhone.value          = box.read('userPhone') ?? '';
    userAddress.value        = box.read('userAddress') ?? '';
    userHospital.value       = box.read('userHospital') ?? '';
    userResponsibilities.value = box.read('userResponsibilities') ?? '';
    profileImagePath.value   = box.read('profileImagePath') ?? '';
    // استعادة الصورة من Base64
    final b64 = box.read('profileImageBase64') as String?;
    if (b64 != null && b64.isNotEmpty) {
      try {
        profileImageBytes.value = base64Decode(b64);
      } catch (_) {}
    }
  }

  void updateProfile({
    required String name,
    required String role,
    required String email,
    required String phone,
    required String address,
    required String hospital,
    required String responsibilities,
    required String imagePath,
    Uint8List? imageBytes,
  }) {
    // تحديث المتغيرات
    userName.value           = name;
    userRole.value           = role;
    userEmail.value          = email;
    userPhone.value          = phone;
    userAddress.value        = address;
    userHospital.value       = hospital;
    userResponsibilities.value = responsibilities;
    profileImagePath.value   = imagePath;

    // تخزين القيم في GetStorage
    box.write('userName', name);
    box.write('userRole', role);
    box.write('userEmail', email);
    box.write('userPhone', phone);
    box.write('userAddress', address);
    box.write('userHospital', hospital);
    box.write('userResponsibilities', responsibilities);
    box.write('profileImagePath', imagePath);

    // تخزين الصورة كسلسلة Base64
    if (imageBytes != null) {
      final b64 = base64Encode(imageBytes);
      box.write('profileImageBase64', b64);
      profileImageBytes.value = imageBytes;
    }
  }
}
class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService apiService;

  ProfileRepositoryImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    return apiService.putWithFile(
      endpoint: '/secretary/profile',
      data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'address': address,
      },
      fileField: 'image',
      file: imageFile,
    );
  }
}