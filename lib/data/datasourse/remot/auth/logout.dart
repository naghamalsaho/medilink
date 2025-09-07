import 'package:dartz/dartz.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/api_link.dart';

class LogoutDataSource {
  final Crud crud;
  LogoutDataSource(this.crud);

  /// POST /logout with auth headers
  Future<Either<StatusRequest, bool>> logout() async {
    try {
      final url = AppLink.logout;
      print('[logoutDataSource] POST $url');

      // استخدم postDataWithHeaders ليضيف Authorization و Accept-Language إلخ
      final map = await crud.postDataWithHeaders(url, <String, dynamic>{});
      print('[logoutDataSource] response: $map');

      if (map is Map && map['success'] == true) {
        return Right(true);
      } else {
        // optional: طباعة رسالة الخطأ التفصيلية من السيرفر
        print('[logoutDataSource] failed, server message: ${map['message']}');
        return Left(StatusRequest.failure);
      }
    } catch (e, st) {
      print('[logoutDataSource] exception: $e\n$st');
      return Left(StatusRequest.offlineFail);
    }
  }
}
