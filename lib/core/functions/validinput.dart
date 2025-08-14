import 'package:get/get.dart';

String? validInput(String val, int min, int max, String type) {
 
  if (val.isEmpty) {
    return "The field cannot be empty";
  }

  switch (type) {
    case 'email':
      if (!GetUtils.isEmail(val)) {
        return "Invalid email";
      }
      break;

    case 'phone':
      final numeric = val.replaceAll(RegExp(r'\D'), '');
      if (numeric.length != 10) {
        return " The phone number must be 10 digits long. ";
      }
      if (!GetUtils.isPhoneNumber(val)) {
        return "Invalid phone number";
      }
      break;

    case 'role':
     
      const allowedRoles = [
        'secretary ',
        ' center admin',
        ' admin',
        ' ministry',
      ];
      if (!allowedRoles.contains(val)) {
        return "The job must be: ${allowedRoles.join('، ')}";
      }
      break;

    
    default:
      break;
  }

  
  if (val.length < min) {
    return "Must be at least $min characters long";
  }
  if (val.length > max) {
    return "Must not exceed $max characters";
  }

  return null; 
}
