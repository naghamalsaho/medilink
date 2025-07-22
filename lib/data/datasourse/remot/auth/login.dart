import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';

class LoginData {
  final Crud crud;
  LoginData(this.crud);

  Future<Map<String, dynamic>> postData(
    String login,
    String password,
    String role,
  ) async {
    return await crud.postData(AppLink.logIn, {
      "login": login,
      "password": password,
      // "role": "secretary", // تأكد من تطابق القيمة مع ما يطلبه السيرفر
      "role": role,
    });
  }
}
