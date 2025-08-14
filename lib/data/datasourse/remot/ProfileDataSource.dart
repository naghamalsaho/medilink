import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/services/MyServices.dart';

import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'dart:io';

import '../../../models/profile_model.dart';
class ProfileDataSource {
  final Crud crud;
  ProfileDataSource(this.crud);

  Future<Either<StatusRequest, ProfileModel>> fetchProfile() async {
    final result = await crud.getData(AppLink.profile);
    return result.fold(
      (l) => Left(l),
      (r) {
        if (r['success'] == true && r['data'] != null) {
          return Right(ProfileModel.fromJson(r['data'] as Map<String, dynamic>));
        }
        return Left(StatusRequest.failure);
      },
    );
  }

  Future<Either<StatusRequest, ProfileModel>> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    final body = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
    final responseMap = await crud.putData(AppLink.updateProfile, body);
    print('🔄 RAW updateProfile response: \$responseMap');

    if (responseMap['success'] == true && responseMap['data'] != null) {
      final profile = ProfileModel.fromJson(
        responseMap['data'] as Map<String, dynamic>,
      );
      return Right(profile);
    } else {
      return Left(StatusRequest.failure);
    }
  }

  Future<Either<StatusRequest, String>> uploadPhoto(dynamic fileSource) async {
    try {
      Uint8List fileBytes;
      String fileName;

      if (fileSource is File) {
        fileBytes = await fileSource.readAsBytes();
        fileName = fileSource.path.split('/').last;
      } else if (fileSource is XFile) {
        fileBytes = await fileSource.readAsBytes();
        fileName = fileSource.name;
      } else {
        return Left(StatusRequest.failure);
      }

      final res = await crud.postFileAndData(
        AppLink.uploadPhoto,
        {},
        'profile_photo',
        fileBytes,
        fileName,
      );

      return res.fold(
        (l) => Left(l),
        (map) => (map['success'] == true && map['data']?['profile_photo'] != null)
            ? Right(map['data']['profile_photo'] as String)
            : Left(StatusRequest.failure),
      );
    } catch (e) {
      print("Upload photo error: \$e");
      return Left(StatusRequest.serverfailure);
    }
  }
}