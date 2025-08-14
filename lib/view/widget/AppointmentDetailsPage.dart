// // lib/view/SecretaryScreens/appointment_details_page.dart
// import 'package:flutter/material.dart';

// class AppointmentDetailsPage extends StatelessWidget {
//   final Map appt;

//   const AppointmentDetailsPage({Key? key, required this.appt}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Appointment Details")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text("Patient: ${appt['patient_name'] ?? '-'}"),
//             Text("Phone: ${appt['patient_phone'] ?? '-'}"),
//             Text("Doctor: ${appt['doctor_name'] ?? '-'}"),
//             Text("Center: ${appt['center_name'] ?? '-'}"),
//             Text("Specialty: ${appt['specialty'] ?? '-'}"),
//             Text("Date: ${appt['requested_date'] ?? '-'}"),
//             Text("Time: ${appt['requested_time'] ?? '-'}"),
//             Text("Status: ${appt['status'] ?? '-'}"),
//             if ((appt['notes'] ?? '').toString().isNotEmpty)
//               Text("Notes: ${appt['notes']}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
