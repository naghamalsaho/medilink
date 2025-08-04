import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/response/response.dart' as getx;
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';

class PatientsData {
  final Crud crud;
  PatientsData(this.crud);
  //=================================================
  Future<Either<StatusRequest, Map>> getPatients() async {
    return await crud.getData(AppLink.patients); // الرابط تبع المرضى
  }

  //===================================================
  Future<http.Response> updatePatient(int id, Map<String, dynamic> data) async {
    final url = AppLink.updatePatient(id);
    // استدعاء الدالة مع id مباشرة
    print("🔵 PUT Request to $url");
    print("📤 Sent Body: $data");

    return await crud.putData(url, data);
  }

  //===================================================
  // دالة بحث المرضى
  Future<Either<StatusRequest, Map>> searchPatients(String query) async {
    final url = "${AppLink.searchPatients}?query=$query";
    print("🔍 Search URL: $url"); // لازم يطبع نفس رابط Postman
    return await crud.getData(url);
  }

  //====================================================
}
