import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late final GetStorage box;
  late SharedPreferences sharedPreferences;
  RxInt currentCenterId = 0.obs;

  Future<MyServices> init() async {
    await GetStorage.init();
    box = GetStorage();
    sharedPreferences = await SharedPreferences.getInstance();
    currentCenterId.value = box.read('center_id') ?? 0;

    return this;
  }

  // 👇 لتعيين رقم المركز الحالي
  void setCurrentCenter(int id) {
    currentCenterId.value = id;
    box.write('center_id', id); // حفظه في GetStorage
    sharedPreferences.setInt('center_id', id); // حفظه في SharedPreferences
  }

  // 👇 لاسترجاع رقم المركز الحالي
  int getCurrentCenter() {
    return currentCenterId.value;
  }
}
