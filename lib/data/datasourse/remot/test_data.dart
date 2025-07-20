import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/crud.dart';

class TestData {
  Crud crud;
  TestData(this.crud);
  getData() async {
    var response = await crud.postData(AppLink.logIn, {
      //   "email":,
      //   "password":,
    });
    return response.fold((l) => 1, (r) => r);
  }
}
