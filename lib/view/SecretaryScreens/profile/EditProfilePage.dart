import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/core/functions/validinput.dart';
import 'package:medilink/view/widget/auth/Customtextformauth.dart';
import 'package:medilink/view/widget/profile/PhotoSection.dart';
import 'package:medilink/view/widget/profile/SectionTitle.dart';
import 'package:medilink/view/widget/profile/card.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileController userController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController hospitalController;

  Uint8List? imageBytes;
Uint8List? tempImageBytes;    
  String?    tempImagePath; 
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: userController.name.value);
    roleController = TextEditingController(text: userController.role.value);
    emailController = TextEditingController(text: userController.email.value);
    phoneController = TextEditingController(text: userController.phone.value);
    addressController = TextEditingController(text: userController.address.value);
    hospitalController = TextEditingController(text: userController.hospital.value);
  }

 Future<void> pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked != null) {
    
    await userController.changePhoto(picked);
    
    final bytes = await picked.readAsBytes();
    setState(() {
      tempImageBytes = bytes;
    });
  }
}



void saveProfile() {
  if (!_formKey.currentState!.validate()) return;
  
  userController.name.value = nameController.text;
  userController.role.value = roleController.text;
  userController.email.value = emailController.text;
  userController.phone.value = phoneController.text;
  userController.address.value = addressController.text;
  userController.hospital.value = hospitalController.text;
  
  userController.saveProfile();
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
                   PhotoSection(
            tempImageBytes: tempImageBytes,
            onPickImage: pickImage,
          ),
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
