import 'package:get/get_navigation/src/root/internacionalization.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {"ar": {
     "1":"لوحة التحكم",
     "2":"الاعدادات",
     "3":"ادارة المواعيد",
      "4":"ادارة المرضى",
      "5":"جداول الاطباء",
      "6":"قائمة الانتظار",
      "7":"التقارير",
      "8":"",
  }, "en": { 
    "1":"Dashboard",
    "2":"Settings",
    "3":" Appointment management",
     "4":" Patient management",
      "5":" Doctors schedules  ",
      "6":" waiting list",
      "7":"Reports",
      "8":"",
  }};
}
