import 'package:dartz/dartz.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';

class PatientsData {
  final Crud crud;
  PatientsData(this.crud);

  Future<Either<StatusRequest, Map>> getPatients() async {
    return await crud.getData(AppLink.patients); // الرابط تبع المرضى
  }
}
