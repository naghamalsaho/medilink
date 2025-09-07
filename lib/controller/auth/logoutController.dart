import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/constants/routes.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/data/datasourse/remot/auth/logout.dart';

class AuthController extends GetxController {
  final _dataSource = LogoutDataSource(Get.find());
  var status = StatusRequest.none.obs;

  /// تسجيل الخروج: ينادي الـ API ثم يمسح التوكن محلياً ويعيد الى شاشة الدخول
  Future<void> logout() async {
    status.value = StatusRequest.loading;

    final res = await _dataSource.logout();
    res.fold(
      (err) {
        status.value = err;
        Get.snackbar('Error', 'Logout failed');
      },
      (ok) async {
        status.value = StatusRequest.success;

        // مسح أي بيانات مخزنة في MyServices بأكثر من طريقة متوقعة
        try {
          final ms =
              Get.isRegistered<MyServices>() ? Get.find<MyServices>() : null;
          if (ms != null) {
            try {
              // شائع: MyServices يحتفظ بـ SharedPreferences داخل حقل sharedPreferences
              if (ms.sharedPreferences != null) {
                await ms.sharedPreferences.remove('token');
                await ms.sharedPreferences.remove('user'); // إن وجدت
              }
            } catch (_) {}

            try {
              // قد يكون لدى MyServices دالة clear() أو logout()
              // نتحقق بطريقة آمنة بدون رمي استثناءات
              final dynamic dyn = ms;
              if (dyn != null) {
                try {
                  if (dyn.clear is Function) {
                    await dyn.clear();
                  } else if (dyn.logout is Function) {
                    await dyn.logout();
                  } else if (dyn.removeToken is Function) {
                    await dyn.removeToken();
                  }
                } catch (_) {}
              }
            } catch (_) {}
          }
        } catch (_) {}

        // اذهب إلى شاشة تسجيل الدخول وامسح الستاك
        // تأكد أن '/Login' موجود في المسارات لديك، غيّره إذا لازم
        Get.offAllNamed(AppRoute.splash);

        Get.snackbar('Done', 'Logged out successfully');
      },
    );
  }
}
