import 'package:get/get.dart';
import 'package:medilink/core/class/statusrequest.dart';

StatusRequest handlingData(Response response) {
  if (response.status.hasError) {
    if (response.statusCode == null) {
      return StatusRequest.serverfailure;
    }
    if (response.statusCode == 500 || response.statusCode == 404) {
      return StatusRequest.serverfailure;
    }
    return StatusRequest.failure;
  } else {
    return StatusRequest.success;
  }
}
