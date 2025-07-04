import 'package:flutter/material.dart';

class EditPatientDialog extends StatefulWidget {
  final String name, email, phone, age, lastVisit, status;

  const EditPatientDialog({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.lastVisit,
    required this.status,
    required String condition,
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
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: "Status"),
                  items:
                      ['Active', 'Follow-up', 'Inactive']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Send updated data to backend here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Patient updated successfully")),
              );
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
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value))
      return 'Invalid email format';
    return null;
  }
}
