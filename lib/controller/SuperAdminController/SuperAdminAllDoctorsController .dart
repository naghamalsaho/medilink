// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:medilink/api_link.dart';

// class SuperAdminAllDoctorsController extends GetxController {
//   var allDoctors = <Map<String, dynamic>>[].obs;
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllDoctors();
//   }

//   Future<void> fetchAllDoctors() async {
//     try {
//       isLoading(true);
//       var response = await http.get(
//         Uri.parse(AppLink.allDoctorsSuperAdmin),
//         headers: {
//           'Authorization': 'Bearer ${AppLink.token}',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         var body = jsonDecode(response.body);
//         allDoctors.value = List<Map<String, dynamic>>.from(body['data']);
//       } else {
//         allDoctors.clear();
//       }
//     } catch (e) {
//       print("Error fetching all doctors: $e");
//       allDoctors.clear();
//     } finally {
//       isLoading(false);
//     }
//   }
// }
