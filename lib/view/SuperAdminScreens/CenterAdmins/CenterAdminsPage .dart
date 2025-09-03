import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController centerNameController = TextEditingController();
    final TextEditingController centerLocationController =
        TextEditingController();
    final TextEditingController issuedByController = TextEditingController();
    final TextEditingController issueDateController = TextEditingController();
    final TextEditingController amountController =
        TextEditingController(); // 🔹 جديد

    // 🔹 بدل ما نخزن path صار نخزن bytes + اسم الملف (يدعم الويب)
    Rx<Uint8List?> licenseFileBytes = Rx<Uint8List?>(null);
    RxString licenseFileName = "".obs;

    RxBool obscurePassword = true.obs; // 🔹 للتحكم بإظهار/إخفاء الباسورد

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register Center Admin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Full Name + Email
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Full Name", fullNameController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField("Email", emailController)),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Phone + Password
                Row(
                  children: [
                    Expanded(child: _buildTextField("Phone", phoneController)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => TextField(
                          controller: passwordController,
                          obscureText: obscurePassword.value,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                obscurePassword.value = !obscurePassword.value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Center Name + Center Location
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "Center Name",
                        centerNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        "Center Location",
                        centerLocationController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Issued By + Issue Date (مع تقويم)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Issued By", issuedByController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: issueDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Issue Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            issueDateController.text =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 License File Picker (يدعم الويب)
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          licenseFileName.value.isEmpty
                              ? "No file selected"
                              : licenseFileName.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.blue),
                      onPressed: () async {
                        // 🔹 يجب أن يكون هذا مباشرة داخل onPressed
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'png'],
                          withData: true, // مهم للويب
                        );
                        if (result != null &&
                            result.files.single.bytes != null) {
                          licenseFileBytes.value = result.files.single.bytes;
                          licenseFileName.value = result.files.single.name;
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 🔹 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.registerCenterAdmin(
                          fullName: fullNameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                          centerName: centerNameController.text,
                          centerLocation: centerLocationController.text,
                          issuedBy: issuedByController.text,
                          issueDate: issueDateController.text,
                          licenseFileBytes: licenseFileBytes.value,
                          licenseFileName:
                              licenseFileName.value.isNotEmpty
                                  ? licenseFileName.value
                                  : null,
                          amount: amountController.text, // بدل double.tryParse
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  // Widget _buildTextField(
  //   String label,
  //   TextEditingController controller, {
  //   bool isPassword = false,
  // }) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: isPassword,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }
}
