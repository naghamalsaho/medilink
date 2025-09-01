import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/CenterAdminsController%20.dart';

class CenterAdminsPage extends StatelessWidget {
  CenterAdminsPage({super.key});
  final CenterAdminsController controller = Get.put(CenterAdminsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Center Admins",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showRegisterAdminDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Center Admin"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              controller.adminsList.isEmpty
                  ? const Center(
                    child: Text(
                      "No Center Admins Found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.adminsList.length,
                    itemBuilder: (context, index) {
                      var admin = controller.adminsList[index];
                      bool isActive = admin["is_active"] ?? true;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    admin["profile_photo"] != null
                                        ? NetworkImage(admin["profile_photo"])
                                        : null,
                                child:
                                    admin["profile_photo"] == null
                                        ? const Icon(Icons.person, size: 30)
                                        : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      admin["full_name"] ?? "-",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      admin["email"] ?? "-",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      admin["phone"] ?? "-",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                                onPressed:
                                    () =>
                                        controller.fetchAdminById(admin["id"]),
                              ),
                              Switch(
                                value: isActive,
                                activeColor: Colors.blue,
                                inactiveThumbColor: Colors.grey,
                                onChanged: (value) {
                                  controller.toggleAdminStatus(admin["id"]);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                  size: 28,
                                ),
                                onPressed:
                                    () => controller.showEditAdminDialog(admin),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      }),
    );
  }

  void _showRegisterAdminDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController centerNameController = TextEditingController();
    final TextEditingController licenseController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Register Center Admin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField("Full Name", nameController),
              const SizedBox(height: 12),
              _buildTextField("Email", emailController),
              const SizedBox(height: 12),
              _buildTextField("Phone", phoneController),
              const SizedBox(height: 12),
              _buildTextField("Password", passwordController, isPassword: true),
              const SizedBox(height: 12),
              _buildTextField("Center Name", centerNameController),
              const SizedBox(height: 12),
              _buildTextField("License Number", licenseController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.registerCenterAdmin(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                        centerName: centerNameController.text,
                        license: licenseController.text,
                        licenseNumber: '',
                        fullName: '',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
