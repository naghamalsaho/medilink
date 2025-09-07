// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:medilink/api_link.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SuperAdminAllDoctorsPage extends StatelessWidget {
//   SuperAdminAllDoctorsPage({super.key});

//   final controller = Get.put(SuperAdminAllDoctorsController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: const Text("All Doctors"),
//         backgroundColor: const Color(0xFF00ACC1),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value)
//           return const Center(child: CircularProgressIndicator());

//         final allDoctors = controller.allDoctors;
//         final pendingDoctors =
//             allDoctors
//                 .where((d) => d['doctor_profile']?['status'] == 'pending')
//                 .toList();

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.pending_actions),
//                 label: const Text("Pending Doctors"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF00ACC1),
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 onPressed: () {
//                   if (pendingDoctors.isEmpty) {
//                     Get.snackbar(
//                       "Info",
//                       "No pending doctors found",
//                       snackPosition: SnackPosition.BOTTOM,
//                     );
//                     return;
//                   }

//                   Get.defaultDialog(
//                     title: "Pending Doctors",
//                     content: SizedBox(
//                       height: 400,
//                       width: double.maxFinite,
//                       child: ListView.builder(
//                         itemCount: pendingDoctors.length,
//                         itemBuilder: (context, index) {
//                           final doctor = pendingDoctors[index];
//                           final doctorId = doctor['doctor_profile']?['id'] ?? 0;
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               title: Text(
//                                 doctor['user']?['full_name'] ?? "No name",
//                               ),
//                               subtitle: Text(
//                                 "Status: ${doctor['doctor_profile']?['status'] ?? "-"}",
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                     ),
//                                     onPressed: () {
//                                       controller.approveDoctor(doctorId);
//                                       Get.back();
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.cancel,
//                                       color: Colors.red,
//                                     ),
//                                     onPressed: () {
//                                       controller.rejectDoctor(doctorId);
//                                       Get.back();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     textConfirm: "Close",
//                     confirmTextColor: Colors.white,
//                     buttonColor: const Color(0xFF00ACC1),
//                     onConfirm: () => Get.back(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: allDoctors.length,
//                 itemBuilder: (context, index) {
//                   final doctor = allDoctors[index];
//                   final doctorId = doctor['doctor_profile']?['id'] ?? 0;
//                   final status =
//                       doctor['doctor_profile']?['status'] ?? "No status";

//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       leading: CircleAvatar(
//                         backgroundColor:
//                             status == 'approved' ? Colors.green : Colors.orange,
//                         child: const Icon(
//                           Icons.medical_services,
//                           color: Colors.white,
//                         ),
//                       ),
//                       title: Text(doctor['user']?['full_name'] ?? "No name"),
//                       subtitle: Text("Status: $status"),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.visibility, color: Colors.blue),
//                         onPressed: () => controller.showDoctorDetails(doctor),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

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
//         Uri.parse(AppLink.pendingDoctors),
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
//       print("Error fetching doctors: $e");
//       allDoctors.clear();
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> approveDoctor(int doctorId) async {
//     try {
//       var response = await http.post(
//         Uri.parse(
//           "https://medical.doctorme.site/api/super-admin/doctors/$doctorId/approve",
//         ),
//         headers: {
//           'Authorization': 'Bearer ${AppLink.token}',
//           'Accept': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Doctor approved successfully");
//         fetchAllDoctors();
//       } else {
//         Get.snackbar("Error", "Failed to approve doctor");
//       }
//     } catch (e) {
//       print("Error approving doctor: $e");
//     }
//   }

//   Future<void> rejectDoctor(int doctorId) async {
//     try {
//       var response = await http.post(
//         Uri.parse(
//           "https://medical.doctorme.site/api/super-admin/doctors/$doctorId/reject",
//         ),
//         headers: {
//           'Authorization': 'Bearer ${AppLink.token}',
//           'Accept': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Doctor rejected successfully");
//         fetchAllDoctors();
//       } else {
//         Get.snackbar("Error", "Failed to reject doctor");
//       }
//     } catch (e) {
//       print("Error rejecting doctor: $e");
//     }
//   }

//   void showDoctorDetails(Map<String, dynamic> doctor) async {
//     final profile = doctor['doctor_profile'] ?? {};
//     final user = doctor['user'] ?? {};

//     Get.defaultDialog(
//       title: "Doctor Profile",
//       titleStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Full Name: ${user['full_name'] ?? "-"}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Specialty: ${profile['specialty_name'] ?? "-"}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Status: ${profile['status'] ?? "-"}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Experience: ${profile['years_of_experience'] ?? "-"} years",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Text(
//                   "Certificate: ",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       final url =
//                           "https://medical.doctorme.site/${profile['certificate'] ?? ""}";
//                       Uri uri = Uri.parse(url);
//                       if (await canLaunchUrl(uri))
//                         await launchUrl(uri);
//                       else
//                         Get.snackbar(
//                           "Error",
//                           "Cannot open certificate",
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                     },
//                     child: Text(
//                       profile['certificate'] ?? "-",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       contentPadding: const EdgeInsets.all(20),
//       radius: 16,
//       textConfirm: "Close",
//       confirmTextColor: Colors.white,
//       buttonColor: const Color(0xFF00ACC1),
//       onConfirm: () => Get.back(),
//     );
//   }
// }
