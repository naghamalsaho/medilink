import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/core/functions/validinput.dart';
import 'package:medilink/view/widget/auth/Customtextformauth.dart';
import 'package:medilink/view/widget/profile/SectionTitle.dart';
import 'package:medilink/view/widget/profile/card.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController hospitalController;

  Uint8List? imageBytes;
Uint8List? tempImageBytes;    // هذا للاحتفاظ بالبايتات مؤقتًا
  String?    tempImagePath; 
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: userController.userName.value);
    roleController = TextEditingController(text: userController.userRole.value);
    emailController = TextEditingController(text: userController.userEmail.value);
    phoneController = TextEditingController(text: userController.userPhone.value);
    addressController = TextEditingController(text: userController.userAddress.value);
    hospitalController = TextEditingController(text: userController.userHospital.value);
  }

  Future<void> pickImage() async {
     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked != null) {
    final bytes = await picked.readAsBytes();
    setState(() {
      tempImageBytes = bytes;
      tempImagePath  = picked.path;
    });
      userController.profileImageBytes.value = bytes;
      if (!kIsWeb) userController.profileImagePath.value = picked.path;
    }
  }

  void saveProfile() {
  if (!_formKey.currentState!.validate()) return;
  userController.updateProfile(
    name:             nameController.text,
    role:             roleController.text,
    email:            emailController.text,
    phone:            phoneController.text,
    address:          addressController.text,
    hospital:         hospitalController.text,
    responsibilities: userController.userResponsibilities.value,
    imagePath:        tempImagePath ?? userController.profileImagePath.value,
    imageBytes:       tempImageBytes,
  );
  Get.back();
}



  Widget _buildPhotoSection() {
    return ReusableCard(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 100,
                  height: 100,
                 child: Obx(() {
  if (tempImageBytes != null) {
    return Image.memory(tempImageBytes!, fit: BoxFit.cover);
  }
  if (userController.profileImageBytes.value != null) {
    return Image.memory(userController.profileImageBytes.value!, fit: BoxFit.cover);
  }
  if (!kIsWeb && userController.profileImagePath.value.isNotEmpty) {
    return Image.file(File(userController.profileImagePath.value), fit: BoxFit.cover);
  }
  return Lottie.asset('assets/lottie/Animationprofile.json', fit: BoxFit.cover);
}),


                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.camera_alt, size: 20, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SectionTitle('الصورة الشخصية'),
          const SizedBox(height: 4),
          const SectionSubtitle(
              'اضغط على الأيقونة لتغيير صورتك الشخصية. يُفضل استخدام صورة واضحة ومهنية.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  automaticallyImplyLeading: false,title: const Text('تعديل الملف الشخصي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPhotoSection(),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (ctx, constraints) {
                    final itemWidth = (constraints.maxWidth - 16) / 2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: ReusableCard(
                            child: Customtextformauth(
                              labeltext: 'الاسم',
                              iconData: Icons.person,
                              mycontroller: nameController,
                              valid: (val) => validInput(val!, 3, 50, 'username'),
                              type: 'username',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: ReusableCard(
                            child: Customtextformauth(
                              labeltext: 'الهاتف',
                              iconData: Icons.phone,
                              mycontroller: phoneController,
                              valid: (val) => validInput(val!, 7, 15, 'phone'),
                              type: 'phone',
                            ),
                          ),
                        ),
                        SizedBox(
  width: itemWidth,
  child: ReusableCard(
    child: Customtextformauth(
      labeltext: 'الدور الوظيفي',
      iconData: Icons.work,
      mycontroller: roleController,
      valid: (val) => validInput(val!, 3, 50, 'text'),
      type: 'text',
    ),
  ),
),
SizedBox(
  width: itemWidth,
  child: ReusableCard(
    child: Customtextformauth(
      labeltext: 'البريد الإلكتروني',
      iconData: Icons.email,
      mycontroller: emailController,
      valid: (val) => validInput(val!, 5, 100, 'email'),
      type: 'email',
    ),
  ),
),
SizedBox(
  width: itemWidth,
  child: ReusableCard(
    child: Customtextformauth(
      labeltext: 'العنوان',
      iconData: Icons.location_on,
      mycontroller: addressController,
      valid: (val) => validInput(val!, 5, 100, 'text'),
      type: 'text',
    ),
  ),
),
SizedBox(
  width: itemWidth,
  child: ReusableCard(
    child: Customtextformauth(
      labeltext: 'المستشفى',
      iconData: Icons.local_hospital,
      mycontroller: hospitalController,
      valid: (val) => validInput(val!, 3, 100, 'text'),
      type: 'text',
    ),
  ),
),
// ... بقية الحقول بنفس النمط
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                  ReusableCard(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    borderRadius: 16,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 55,
                              width: 140,
                              child: ElevatedButton(
                                onPressed: saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('حفظ التغييرات'),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              height: 55,
                              width: 140,
                              child: OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: const Text('إلغاء'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const InfoBoxText(
                          '• تأكد من صحة البريد الإلكتروني ورقم الهاتف.\n'
                          '• استخدام معلومات دقيقة ومحدثة.\n'
                          '• سيتم حفظ التغييرات تلقائيًا بعد التأكيد.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
