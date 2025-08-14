
import 'package:dartz/dartz.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/models/doctor_model.dart';


class DoctorDataSource {
  final Crud crud;
  DoctorDataSource(this.crud);

  Future<Either<StatusRequest, List<DoctorModel>>> fetchAll() async {
    final res = await crud.getData(AppLink.getDoctors);
    return res.fold(
      (err) => Left(err),
      (map) {
        if (map['success'] == true && map['data'] != null) {
          final list = (map['data'] as List)
              .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(list);
        }
        return Left(StatusRequest.failure);
      },
    );
  }
  Future<Either<StatusRequest, List<DoctorModel>>> searchDoctors(String query) =>
    crud.getData('${AppLink.doctorsSearch}?query=$query').then((res) => res.fold(
      (l) => Left(l),
      (r) {
        final list = (r['data'] as List)
            .map((e) => DoctorModel.fromJson(e))
            .toList();
        return Right(list);
      },
    ));
  /// GET one doctor by id
   Future<Either<StatusRequest, DoctorModel>> fetchById(int id) async {
    final res = await crud.getData('${AppLink.getDoctors}/$id');
    return res.fold(
      (err) => Left(err),
      (map) {
        if (map['success'] == true && map['data'] != null) {
          return Right(DoctorModel.fromJson(map['data'] as Map<String, dynamic>));
        }
        return Left(StatusRequest.failure);
      },
    );
  }
  Future<Either<StatusRequest, List<Map<String, dynamic>>>> fetchAppointmentsForDoctor(int doctorId) async {
    final url = AppLink.doctorAppointments(doctorId.toString());
    print(' [DoctorDataSource] GET $url');
    final res = await crud.getData(url);
    return res.fold(
      (l) => Left(l),
      (r) {
        if (r['success'] == true && r['data'] is List) {
         
          return Right(List<Map<String, dynamic>>.from(r['data'] as List));
        }
        return Left(StatusRequest.failure);
      },
    );
  } 
}
