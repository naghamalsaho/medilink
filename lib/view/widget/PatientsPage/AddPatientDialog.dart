import 'package:flutter/material.dart';

class AddPatientDialog extends StatelessWidget {
  const AddPatientDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    String gender = 'Male';

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
              const Text("Full name of the patientEnter the patient's name"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("Enter the patient's name"),
                controller: nameController,
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
                        DropdownButtonFormField<String>(
                          value: gender,
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
                            if (value != null) gender = value;
                          },
                          decoration: _inputDecoration("Gender"),
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
                          controller: ageController,
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
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),
              const Text("Email"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("example@email.com"),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              const Text("Address"),
              const SizedBox(height: 6),
              TextField(
                decoration: _inputDecoration("Enter the full address"),
                controller: addressController,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: تنفيذ الإضافة الفعلية
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5FFF),
                    ),
                    child: const Text("Save"),
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
