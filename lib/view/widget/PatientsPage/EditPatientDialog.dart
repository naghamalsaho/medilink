import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/PatientsController.dart';

class EditPatientDialog extends StatefulWidget {
  final String name, email, phone, age, lastVisit, status, condition;
  final int patientId;

  const EditPatientDialog({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.lastVisit,
    required this.status,
    required this.condition,
    required this.patientId,
  });

  @override
  State<EditPatientDialog> createState() => _EditPatientDialogState();
}

class _EditPatientDialogState extends State<EditPatientDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  late TextEditingController lastVisitController;
  late TextEditingController conditionController;
  late String selectedStatus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    ageController = TextEditingController(text: widget.age);
    lastVisitController = TextEditingController(text: widget.lastVisit);
    conditionController = TextEditingController(text: widget.condition);
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Patient"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField("Name", nameController),
                _buildTextField(
                  "Email",
                  emailController,
                  validator: _validateEmail,
                ),
                _buildTextField("Phone", phoneController),
                _buildTextField("Age", ageController),
                _buildTextField("Last Visit", lastVisitController),
                _buildTextField("Condition", conditionController),
                DropdownButtonFormField<String>(
                  value:
                      [
                            "Active",
                            "Follow-up",
                            "Inactive",
                          ].contains(widget.status)
                          ? widget.status
                          : "Active", // للقيمة الافتراضية                  decoration: const InputDecoration(labelText: "Status"),
                  items:
                      ["Active", "Follow-up", "Inactive"]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final controller = Get.find<PatientsController>();
              await controller.updatePatient(widget.patientId, {
                'full_name': nameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
                'age': int.tryParse(ageController.text) ?? 0,
                'last_visit': lastVisitController.text,
                'status': selectedStatus,
                'condition': conditionController.text,
              });
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator:
            validator ?? (val) => val!.isEmpty ? "$label can't be empty" : null,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }
}
