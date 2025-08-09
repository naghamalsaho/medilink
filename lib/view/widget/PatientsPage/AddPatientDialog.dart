import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/AddPatientController.dart';
import 'package:medilink/controller/PatientsController.dart';

class AddPatientDialog extends StatelessWidget {
  AddPatientDialog({super.key});

  final AddPatientController controller = Get.put(AddPatientController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' Add a new patient ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // الاسم
              const Text("Full name of the patient"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("Enter the patient's name"),
                controller: controller.nameController,
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  // الجنس
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gender"),
                        const SizedBox(height: 6),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.gender.value,
                            items: const [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text("Male"),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text("Female"),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null)
                                controller.gender.value = value;
                            },
                            decoration: _inputDecoration("Gender"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // العمر
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Age"),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: _inputDecoration("Age"),
                          controller: controller.birthDateController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text("Phone number "),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("09xxxxxxxx"),
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),
              const Text("Email"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("example@email.com"),
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              const Text("Address"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("Enter the full address"),
                controller: controller.addressController,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      if (!controller.isLoading.value) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("cancel"),
                  ),

                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () async {
                                print("🔵 Save button pressed");
                                await controller.addPatient();
                              },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5FFF),
                      ),
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
