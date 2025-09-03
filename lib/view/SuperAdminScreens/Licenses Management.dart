// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class LicenseController extends GetxController {
//   var licenses = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;

//   final String token = "YOUR_BEARER_TOKEN"; // استبدلها بالتوكن تبعك

//   @override
//   void onInit() {
//     super.onInit();
//     fetchLicenses();
//   }

//   Future<void> fetchLicenses() async {
//     try {
//       isLoading.value = true;
//       final response = await http.get(
//         Uri.parse("https://medical.doctorme.site/api/superadmin/licenses"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         licenses.value = List<Map<String, dynamic>>.from(data["data"]);
//       } else {
//         Get.snackbar("Error", "Failed to load licenses");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateLicenseStatus(int licenseId, String status) async {
//     // هاد مجرد مثال (حسب الـ API endpoint اللي بيغير status)
//     final response = await http.post(
//       Uri.parse(
//         "https://medical.doctorme.site/api/superadmin/licenses/$licenseId/update-status",
//       ),
//       headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
//       body: {"status": status},
//     );

//     if (response.statusCode == 200) {
//       Get.snackbar("Success", "License status updated");
//       fetchLicenses();
//     } else {
//       Get.snackbar("Error", "Failed to update license");
//     }
//   }
// }

// class LicensesManagementPage extends StatelessWidget {
//   LicensesManagementPage({super.key});

//   final LicenseController controller = Get.put(LicenseController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Licenses Management",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF111827),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (controller.licenses.isEmpty) {
//                   return const Center(child: Text("No licenses found."));
//                 }

//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: const [
//                       DataColumn(label: Text("ID")),
//                       DataColumn(label: Text("User")),
//                       DataColumn(label: Text("Email")),
//                       DataColumn(label: Text("Center")),
//                       DataColumn(label: Text("Issued By")),
//                       DataColumn(label: Text("Issue Date")),
//                       DataColumn(label: Text("Status")),
//                       DataColumn(label: Text("Actions")),
//                     ],
//                     rows:
//                         controller.licenses.map((license) {
//                           return DataRow(
//                             cells: [
//                               DataCell(Text("${license["id"]}")),
//                               DataCell(
//                                 Text(license["user"]["full_name"] ?? ""),
//                               ),
//                               DataCell(Text(license["user"]["email"] ?? "")),
//                               DataCell(Text(license["center"]["name"] ?? "")),
//                               DataCell(Text(license["issued_by"] ?? "")),
//                               DataCell(Text(license["issue_date"] ?? "")),
//                               DataCell(
//                                 Text(
//                                   license["status"],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color:
//                                         license["status"] == "approved"
//                                             ? Colors.green
//                                             : license["status"] == "rejected"
//                                             ? Colors.red
//                                             : Colors.orange,
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Row(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed:
//                                           () => controller.updateLicenseStatus(
//                                             license["id"],
//                                             "approved",
//                                           ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.green,
//                                       ),
//                                       child: const Text("Approve"),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     ElevatedButton(
//                                       onPressed:
//                                           () => controller.updateLicenseStatus(
//                                             license["id"],
//                                             "rejected",
//                                           ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                       ),
//                                       child: const Text("Reject"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
