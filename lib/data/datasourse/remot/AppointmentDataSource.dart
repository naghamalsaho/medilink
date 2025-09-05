import 'package:dartz/dartz.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/models/appointment_model.dart';

class AppointmentStats {
  final int total, pending, confirmed, complete, cancelled;
  AppointmentStats({
    required this.total,
    required this.pending,
    required this.confirmed,
    required this.complete,
    required this.cancelled,
  });
}

class AppointmentStatsDataSource {
  final Crud crud;
  AppointmentStatsDataSource(this.crud);

  Future<Either<StatusRequest, AppointmentStats>> fetchStats() async {
    final res = await crud.getData(AppLink.appointmentStats);
    return res.fold((l) => Left(l), (r) {
      final d = r['data'] as Map<String, dynamic>;
      return Right(
        AppointmentStats(
          total: d['total_requests'] as int? ?? 0,
          pending: d['pending_requests'] as int? ?? 0,
          confirmed: d['approved_requests'] as int? ?? 0,
          complete: d['today_requests'] as int? ?? 0,
          cancelled: d['rejected_requests'] as int? ?? 0,
        ),
      );
    });
  }

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> fetchAll() async {
    final res = await crud.getData(AppLink.appointmentRequests);
    return res.fold((l) => Left(l), (r) {
      if (r['success'] == true && r['data'] is List) {
        return Right(List<Map<String, dynamic>>.from(r['data']));
      }
      return Left(StatusRequest.failure);
    });
  }

 Future<Either<StatusRequest, List<Map<String, dynamic>>>> fetchToday() async {
  final res = await crud.getData(AppLink.appointmentToday);
  print('[DataSource] fetchToday response raw: $res');
  return res.fold((l) => Left(l), (r) {
    if (r['success'] == true && r['data'] is List) {
      return Right(List<Map<String, dynamic>>.from(r['data']));
    }
    return Left(StatusRequest.failure);
  });
}
  //    Future<Either<StatusRequest, AppointmentModel>> bookAppointment({
  //   required int doctorId,
  //   required String appointmentDate,
  //   String? bookedBy,
  //   required String status,
  //   required String attendanceStatus,
  //   String? notes,
  // }) async {
  //   final body = {
  //     'doctor_id': '$doctorId',
  //     'appointment_date': appointmentDate,
  //    if (bookedBy != null) 'booked_by': bookedBy,
  //     'status': status,
  //     'attendance_status': attendanceStatus,
  //     if (notes != null) 'notes': notes,
  //   };

  //   // postData يعيد Future<Map<String,dynamic>>
  //   final map = await crud.postData(AppLink.bookAppointment, body);

  
  //   if (map['success'] == true && map['data'] != null) {
  
  //     final appt = AppointmentModel.fromJson(map['data'] as Map<String, dynamic>);
  //     return Right(appt);
  //   } else {
  //     return Left(StatusRequest.failure);
  //   }
  // }
  Future<Either<StatusRequest, Map<String, dynamic>>> fetchAppointmentDetails(
    int id,
  ) async {
    final res = await crud.getData('${AppLink.appointmentRequests}/$id');
    return res.fold((l) => Left(l), (r) {
      if (r['success'] == true && r['data'] != null) {
        return Right(r['data']);
      }
      return Left(StatusRequest.failure);
    });
  }

  Future<Either<StatusRequest, Map<String, dynamic>>> approveRequest(
    int id, {
    String? reason,
  }) async {
    final url =
        "https://cors-anywhere.herokuapp.com/https://medical.doctorme.site/api/secretary/appointment-requests/$id/approve";
    final body = <String, dynamic>{};
   
    if (reason != null && reason.isNotEmpty) {
      body['reason'] = reason;
    } else {
      
      body['reason'] = 'No reason provided';
    }

    try {
      print(' [DataSource] POST $url');
      print(' [DataSource] request body: $body');
      final map = await crud.postDataWithHeaders(
        url,
        body,
      ); 
      print(' [DataSource] approve response raw: $map');

      if (map is Map && map['success'] == true) {
        print(' [DataSource] approve success for id=$id');
        return Right(Map<String, dynamic>.from(map));
      } else {
        print(' [DataSource] approve returned failure map for id=$id -> $map');
        return Left(StatusRequest.failure);
      }
    } catch (e, st) {
      print(' [DataSource] approve exception for id=$id -> $e');
      print(st);
      return Left(
        StatusRequest.offlineFail,
      ); 
    }
  }

  Future<Either<StatusRequest, Map<String, dynamic>>> rejectRequest(
    int id, {
    String? reason,
  }) async {
    final url =
        "https://cors-anywhere.herokuapp.com/https://medical.doctorme.site/api/secretary/appointment-requests/$id/reject";
    final body = <String, dynamic>{};
    if (reason != null && reason.isNotEmpty) {
      body['reason'] = reason;
    } else {
      body['reason'] = 'No reason provided';
    }

    try {
      print(' [DataSource] POST $url');
      print(' [DataSource] request body: $body');
      final map = await crud.postDataWithHeaders(url, body);
      print(' [DataSource] reject response raw: $map');

      if (map is Map && map['success'] == true) {
        print(' [DataSource] reject success for id=$id');
        return Right(Map<String, dynamic>.from(map));
      } else {
        print(' [DataSource] reject returned failure map for id=$id -> $map');
        return Left(StatusRequest.failure);
      }
    } catch (e, st) {
      print(' [DataSource] reject exception for id=$id -> $e');
      print(st);
      return Left(StatusRequest.offlineFail);
    }
  }

  Future<Either<StatusRequest, AppointmentModel>> bookAppointment({
  required int doctorId,
  required int patientId,
  required String appointmentDate, // ISO string
  required String status,
  required String attendanceStatus,
  String? notes,
}) async {
  final body = <String, dynamic>{
  'doctor_id': '$doctorId',
  'patient_id': '$patientId',
  'requested_date': appointmentDate,   // هذا السطر ضروري بصيغة "Y-m-d H:i:s"
  'status': status,
  'attendance_status': attendanceStatus,
};


  if (notes != null && notes.isNotEmpty) {
    body['notes'] = notes;
  }

  print(' [DataSource] POST ${AppLink.bookAppointment} body: $body');

  final map = await crud.postDataWithHeaders(AppLink.bookAppointment, body);

  print(' [DataSource] bookAppointment response: $map');

  if (map is Map && map['success'] == true && map['data'] != null) {
    try {
      final appt = AppointmentModel.fromJson(
        map['data'] as Map<String, dynamic>,
      );
      return Right(appt);
    } catch (e) {
      print(' [DataSource] bookAppointment parse error: $e');
      return Left(StatusRequest.failure);
    }
  } else {
    print(' [DataSource] bookAppointment failed -> ${map.toString()}');
    return Left(StatusRequest.failure);
  }
}

Future<Either<StatusRequest, Map<String, dynamic>>> bookAppointmentMinimal({
  required int doctorId,
  required int patientId,
  required String requestedDate, // 'yyyy-MM-dd HH:mm:ss'
  String? notes,
}) async {
  final body = <String, dynamic>{
    'doctor_id': '$doctorId',
    'patient_id': '$patientId',
    'requested_date': requestedDate,
  };
  if (notes != null && notes.isNotEmpty) body['notes'] = notes;

  print(' [DataSource] POST ${AppLink.bookAppointment} body: $body');

  try {
    final map = await crud.postDataWithHeaders(AppLink.bookAppointment, body);
    print(' [DataSource] bookAppointmentMinimal response: $map');

    if (map is Map && map['success'] == true && map['data'] != null) {
      return Right(Map<String, dynamic>.from(map['data']));
    } else {
      print(' [DataSource] bookAppointmentMinimal failed -> $map');
      return Left(StatusRequest.failure);
    }
  } catch (e, st) {
    print(' [DataSource] bookAppointmentMinimal exception: $e');
    print(st);
    return Left(StatusRequest.offlineFail);
  }
}

 Future<Either<StatusRequest, Map<String, dynamic>>> updateAppointment({
  required int id,
  required int doctorId,
  String? appointmentDate, // يفترض أن تكون 'yyyy-MM-dd HH:mm:ss' أو ISO
  required String status,
  required String attendanceStatus,
  String? notes,
  int? patientId,
}) async {
  final url = "${AppLink.update}/$id";

  // أرسل القيم بأنواع سليمة (int للبعض، String للتواريخ)
  final body = <String, dynamic>{
    'doctor_id': doctorId,
    if (appointmentDate != null) 'requested_date': appointmentDate, // <-- المهم: requested_date
    'status': status,
    'attendance_status': attendanceStatus,
    if (notes != null) 'notes': notes,
    if (patientId != null) 'patient_id': patientId,
  };

  print(' [DataSource] updateAppointment PUT $url body: $body');

  try {
    final map = await crud.putWithToken(url, body);
    print(' [DataSource] updateAppointment response: $map');

    if (map is Map && map['success'] == true && map['data'] != null) {
      return Right(Map<String, dynamic>.from(map['data']));
    } else {
      return Left(StatusRequest.failure);
    }
  } catch (e, st) {
    print(' [DataSource] updateAppointment exception: $e');
    print(st);
    return Left(StatusRequest.offlineFail);
  }
}


 
  Future<Either<StatusRequest, Map<String, dynamic>>> deleteAppointment(
    int id,
  ) async {
    final url = "${AppLink.update}/$id";
    print(' [DataSource] deleteAppointment DELETE $url');

    final map = await crud.deleteWithToken(url);
    print(' [DataSource] deleteAppointment response: $map');

    if (map['success'] == true) {
      return Right(Map<String, dynamic>.from(map));
    } else {
      return Left(StatusRequest.failure);
    }
  }

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> fetchIgnored() async {
  final res = await crud.getData(AppLink.appointmentIgnored);
  print('[DataSource] fetchIgnored response raw: $res');
  return res.fold((l) => Left(l), (r) {
    if (r['success'] == true && r['data'] is List) {
      return Right(List<Map<String, dynamic>>.from(r['data']));
    }
    return Left(StatusRequest.failure);
  });
}
Future<Either<StatusRequest, Map<String, dynamic>>> updateAttendance({
  required int appointmentId,
  required String status, // present or absent
}) async {
  final url = "${AppLink.appointmentAttendance}/$appointmentId/attendance";
  final body = {"status": status};

  print("[DataSource] POST $url body: $body");

  try {
    final map = await crud.postDataWithHeaders(url, body);
    print("[DataSource] updateAttendance response: $map");

    if (map is Map && map['success'] == true && map['data'] != null) {
      return Right(Map<String, dynamic>.from(map['data']));
    } else {
      return Left(StatusRequest.failure);
    }
  } catch (e, st) {
    print("[DataSource] updateAttendance exception: $e");
    print(st);
    return Left(StatusRequest.offlineFail);
  }
}

}
