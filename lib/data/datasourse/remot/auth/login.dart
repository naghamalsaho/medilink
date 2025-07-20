// import 'package:medilink/api_link.dart';
// import 'package:medilink/core/class/crud.dart';

// class LoginData {
//   Crud crud;
//   LoginData(this.crud);
//   postData(String login, String password) async {
//     var response = await crud.postData(AppLink.logIn, {
//       "login": login, // ✅ الاسم الصحيح
//       "password": password,
//       "role": "secretary",
//     });
//     return response.fold((l) => l, (r) => r);
//   }
// }
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';

class LoginData {
  final Crud crud;
  LoginData(this.crud);

  Future<Map<String, dynamic>> postData(String login, String password) async {
    return await crud.postData(AppLink.logIn, {
      "login": login,
      "password": password,
      "role": "secretary", // تأكد من تطابق القيمة مع ما يطلبه السيرفر
    });
  }
}
