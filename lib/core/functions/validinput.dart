import 'package:get/get.dart';

String? validInput(String val, int min, int max, String type) {
  // التحقق من الخلو
  if (val.isEmpty) {
    return "لا يمكن أن يكون الحقل فارغًا";
  }

  switch (type) {
    case 'email':
      if (!GetUtils.isEmail(val)) {
        return "البريد الإلكتروني غير صالح";
      }
      break;

    case 'phone':
      final numeric = val.replaceAll(RegExp(r'\D'), '');
      if (numeric.length != 10) {
        return "يجب أن يتكون رقم الهاتف من 10 أرقام";
      }
      if (!GetUtils.isPhoneNumber(val)) {
        return "رقم الهاتف غير صالح";
      }
      break;

    case 'role':
      // قائمة الوظائف المسموح بها
      const allowedRoles = [
        'سكرتيرة طبية',
        'مدير المركز',
        'أدمن عام',
        'وزارة الصحة',
      ];
      if (!allowedRoles.contains(val)) {
        return "الوظيفة يجب أن تكون: ${allowedRoles.join('، ')}";
      }
      break;

    // يمكن إضافة حالات أخرى هنا...
    default:
      break;
  }

  // التحقق من الطول العام
  if (val.length < min) {
    return "يجب ألا يقل الطول عن $min حرفًا";
  }
  if (val.length > max) {
    return "يجب ألا يزيد الطول عن $max حرفًا";
  }

  return null; // صالحة
}
