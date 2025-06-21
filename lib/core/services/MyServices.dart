import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyServices extends GetxService {
  late final GetStorage box;

  Future<MyServices> init() async {
    await GetStorage.init();
    box = GetStorage();
    return this;
  }
}
