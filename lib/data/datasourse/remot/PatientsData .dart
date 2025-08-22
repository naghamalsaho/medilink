import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';

class PatientsData {
  final Crud crud;
  PatientsData(this.crud);
  Future<Either<StatusRequest, Map>> getPatients() async {
    return await crud.getData(AppLink.patients);
  }

  //===================================================
  Future<http.Response> updatePatient(int id, Map<String, dynamic> data) async {
    final url = AppLink.updatePatient(id);
    print(" PUT Request to $url");
    print("Sent Body: $data");

    return await crud.putData2(url, data);
  }

  //===================================================
  Future<Either<StatusRequest, Map>> searchPatients(String query) async {
    final url = "${AppLink.searchPatients}?query=$query";
    print(" Search URL: $url");
    return await crud.getData(url);
  }

  //====================================================
}
