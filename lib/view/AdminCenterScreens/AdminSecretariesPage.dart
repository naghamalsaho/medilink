import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/AdminRoleControllers/AdminSecretariesController%20.dart';

class AdminSecretariesPage extends StatelessWidget {
  AdminSecretariesPage({super.key});
  final AdminSecretariesController controller = Get.put(
    AdminSecretariesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Secretaries Management",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final nameController = TextEditingController();
                    final emailController = TextEditingController();
                    final phoneController = TextEditingController();
                    String selectedShift = "morning";
                    bool isActive = true;

                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text("Add New Secretary"),
                        content: SizedBox(
                          width: 600,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: "Full Name",
                                  ),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                  ),
                                ),
                                TextField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: "Phone",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value: selectedShift,
                                  decoration: const InputDecoration(
                                    labelText: "Shift",
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "morning",
                                      child: Text("Morning"),
                                    ),
                                    DropdownMenuItem(
                                      value: "evening",
                                      child: Text("Evening"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) selectedShift = value;
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text("Active"),
                                  value: isActive,
                                  onChanged: (val) => isActive = val,
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Get.back(),
                          ),
                          ElevatedButton(
                            child: const Text("Add"),
                            onPressed: () {
                              controller.addSecretary({
                                "full_name": nameController.text,
                                "email": emailController.text,
                                "phone": phoneController.text,
                                "shift": selectedShift,
                                "is_active":
                                    isActive, // سيقوم controller بتحويله
                                "role": "secretary", // 🔑 مهم
                              });
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Secretary"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Filter + Search
            Obx(
              () => Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.statusFilter.value,
                        items: const [
                          DropdownMenuItem(
                            value: "all",
                            child: Text("All Status"),
                          ),
                          DropdownMenuItem(
                            value: "active",
                            child: Text("Active"),
                          ),
                          DropdownMenuItem(
                            value: "inactive",
                            child: Text("Inactive"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null)
                            controller.statusFilter.value = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => controller.searchQuery.value = val,
                      decoration: InputDecoration(
                        hintText: "Search secretary...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Table
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.secretariesList.isEmpty) {
                  return const Center(child: Text('No secretaries found'));
                }

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView(
                    children: [
                      _buildTableHeader(),
                      ...controller.filteredSecretaries.map((secretary) {
                        String shift = (secretary['shift'] ?? '---').toString();
                        shift =
                            shift.isNotEmpty ? shift.capitalizeFirst! : '---';

                        return _buildRow(
                          secretary['user_id'] ?? 0, // 👈 المفتاح الصحيح
                          secretary['full_name'] ?? '---',
                          secretary['email'] ?? '---',
                          secretary['phone'] ?? '---',
                          secretary['shift'] ?? '---',
                          secretary['is_active'] ?? false, // 👈 صار Boolean
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Table Header
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Shift",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Actions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Table Row
  Widget _buildRow(
    int id,
    String name,
    String email,
    String phone,
    String shift,
    dynamic active, // خليها dynamic بدل bool
  ) {
    bool isActiveBool =
        active is int ? (active == 1) : active; // 🔑 تحويل int → bool

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 2, child: Text(email)),
          Expanded(flex: 1, child: Text(phone)),
          Expanded(
            flex: 1,
            child: Center(
              child: _buildBadge(shift, Colors.orange.shade100, Colors.orange),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _buildBadge(
                isActiveBool ? "Active" : "Inactive",
                isActiveBool ? Colors.green.shade100 : Colors.red.shade100,
                isActiveBool ? Colors.green : Colors.red,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      final nameController = TextEditingController(text: name);
                      final emailController = TextEditingController(
                        text: email,
                      );
                      final phoneController = TextEditingController(
                        text: phone,
                      );
                      String selectedShift = shift.toLowerCase();
                      bool isActive = isActiveBool;

                      Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text("Edit Secretary"),
                          content: SizedBox(
                            width: 600,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: "Full Name",
                                    ),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                    ),
                                  ),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      labelText: "Phone",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField<String>(
                                    value: selectedShift,
                                    decoration: const InputDecoration(
                                      labelText: "Shift",
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "morning",
                                        child: Text("Morning"),
                                      ),
                                      DropdownMenuItem(
                                        value: "evening",
                                        child: Text("Evening"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) selectedShift = value;
                                    },
                                  ),
                                  SwitchListTile(
                                    title: const Text("Active"),
                                    value: isActive,
                                    onChanged: (val) => isActive = val,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Get.back(),
                            ),
                            ElevatedButton(
                              child: const Text("Update"),
                              onPressed: () {
                                controller.updateSecretary(id, {
                                  "full_name": nameController.text,
                                  "email": emailController.text,
                                  "phone": phoneController.text,
                                  "shift": selectedShift,
                                  "is_active": isActive ? 1 : 0,
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteSecretary(id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Badge Widget
  Widget _buildBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
