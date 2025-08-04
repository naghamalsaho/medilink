// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:medilink/controller/DashbordController.dart';
// import 'package:medilink/core/class/statusrequest.dart';
// import 'package:medilink/view/widget/dashbord/AppointmentListCard.dart';
// import 'package:medilink/view/widget/dashbord/NotificationRow.dart';
// import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
// import 'package:medilink/view/widget/dashbord/WelcomeBanner%20.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: GetBuilder<DashboardController>(
//         init: DashboardController(),
//         builder: (controller) {
//           if (controller.statusRequest == StatusRequest.loading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (controller.statusRequest == StatusRequest.failure) {
//             return const Center(child: Text("فشل في تحميل البيانات"));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const WelcomeBanner(),
//                 const SizedBox(height: 20),

//                 Center(
//                   child: Wrap(
//                     spacing: 16,
//                     runSpacing: 16,
//                     children: [
//                       StatsCard(
//                         title: "Pending Appointments",
//                         value: controller.pendingAppointments.toString(),
//                         badge: "2-",
//                         icon: Icons.access_time,
//                         color: Colors.orange,
//                         token: '',
//                       ),
//                       StatsCard(
//                         title: "New Files",
//                         value: controller.newFiles.toString(),
//                         badge: "3+",
//                         icon: Icons.description_outlined,
//                         color: Colors.purple,
//                         token: '',
//                       ),
//                       StatsCard(
//                         title: "Today's Appointments",
//                         value: controller.todaysAppointments.toString(),
//                         badge: "5+",
//                         icon: Icons.calendar_today_outlined,
//                         color: Colors.green,
//                         token: '',
//                       ),
//                       StatsCard(
//                         title: "Total Patients",
//                         value: controller.totalPatients.toString(),
//                         badge: "12%",
//                         icon: Icons.groups_outlined,
//                         color: Colors.blue,
//                         token: '',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Expanded(
//                       flex: 1,
//                       child: Column(
//                         children: [
//                           ImportantNotifications(),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Expanded(
//                       flex: 2,
//                       child: controller.appointments.isEmpty
//                           ? const Center(child: Text("لا يوجد مواعيد اليوم"))
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: controller.appointments.length,
//                               itemBuilder: (context, index) {
//                                 var item = controller.appointments[index];
//                                 return AppointmentsList(
//                                   patientName: item['patient_name'] ?? "بدون اسم",
//                                   time: item['time'] ?? "بدون وقت",
//                                 );
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
