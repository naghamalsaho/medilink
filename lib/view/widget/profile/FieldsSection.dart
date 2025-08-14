
// import 'package:flutter/material.dart';


// import 'package:medilink/controller/profileController.dart';
// import 'package:medilink/core/functions/validinput.dart';
// import 'package:medilink/view/widget/auth/Customtextformauth.dart';
// import 'package:medilink/view/widget/profile/card.dart';

// class _FieldsSection extends StatelessWidget {
//  final TextEditingController nameController;
//   final TextEditingController phoneController;
//   final TextEditingController roleController;
//   final TextEditingController emailController;
//   final TextEditingController addressController;
//   final TextEditingController hospitalController;

//   const _FieldsSection({
//     required this.nameController,
//     required this.phoneController,
//     required this.roleController,
//     required this.emailController,
//     required this.addressController,
//     required this.hospitalController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (ctx, constraints) {
//         final itemWidth = (constraints.maxWidth - 16) / 2;
//         return Wrap(
//           spacing: 16,
//           runSpacing: 16,
//           children: [
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'الاسم',
//                 iconData: Icons.person,
//                 mycontroller: controller.nameController,
//                 valid: (val) => validInput(val!, , 50, 'username'),
//                 type: 'username',
//               ),
//             ),
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'الهاتف',
//                 iconData: Icons.phone,
//                 mycontroller: controller.phoneController,
//                 valid: (val) => validInput(val!, 7, 15, 'phone'),
//                 type: 'phone',
//               ),
//             ),
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'الدور الوظيفي',
//                 iconData: Icons.work,
//                 mycontroller: controller.roleController,
//                 valid: (val) => validInput(val!, 3, 50, 'text'),
//                 type: 'text',
//               ),
//             ),
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'البريد الإلكتروني',
//                 iconData: Icons.email,
//                 mycontroller: controller.emailController,
//                 valid: (val) => validInput(val!, 5, 100, 'email'),
//                 type: 'email',
//               ),
//             ),
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'العنوان',
//                 iconData: Icons.location_on,
//                 mycontroller: controller.addressController,
//                 valid: (val) => validInput(val!, 5, 100, 'text'),
//                 type: 'text',
//               ),
//             ),
//             _FieldCard(
//               width: itemWidth,
//               child: Customtextformauth(
//                 labeltext: 'المستشفى',
//                 iconData: Icons.local_hospital,
//                 mycontroller: controller.hospital,
//                 valid: (val) => validInput(val!, 3, 100, 'text'),
//                 type: 'text',
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// class _ActionsSection extends StatelessWidget {
//   final ProfileController controller;
//   const _ActionsSection({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return ReusableCard(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       padding: const EdgeInsets.all(16),
//       borderRadius: 16,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 55,
//                 width: 140,
//                 child: ElevatedButton(
//                   onPressed: controller.saveProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: const Text('حفظ التغييرات'),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               SizedBox(
//                 height: 55,
//                 width: 140,
//                 child: OutlinedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: () => Get.back(),
//                   child: const Text('إلغاء'),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 40),
//           const InfoBoxText(
//             '• تأكد من صحة البريد الإلكتروني ورقم الهاتف.\n'
//             '• استخدام معلومات دقيقة ومحدثة.\n'
//             '• سيتم حفظ التغييرات تلقائيًا بعد التأكيد.',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FieldCard extends StatelessWidget {
//   final double width;
//   final Widget child;
//   const _FieldCard({required this.width, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: ReusableCard(child: child),
//     );
//   }
// }