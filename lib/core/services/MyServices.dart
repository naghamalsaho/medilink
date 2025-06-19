import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class MyServices extends GetxService {
  final GetStorage box = GetStorage();
}

Future<void> initServices() async {
  await GetStorage.init();
  Get.put(MyServices());
}
