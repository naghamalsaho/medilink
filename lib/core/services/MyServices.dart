import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late final GetStorage box;
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {
    await GetStorage.init();
    box = GetStorage();
     sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}
