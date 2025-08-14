
import 'package:flutter/material.dart';

class AddDoctorDialog extends StatelessWidget {
  const AddDoctorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 400, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add a new doctor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildTextField(
                  label: 'Full name of the doctor',
                  hint: 'D, Ahmad Ahmad',
                ),
                _buildDropdown(
                  label: 'The specialty',
                  hint: ' Choose The specialty',
                ),
                _buildTextField(label: 'Phone Number', hint: '09xxxxxxxx'),
                _buildTextField(label: 'Email', hint: 'doctor@clinic.com'),
                _buildTextField(
                  label: 'Qualifications',
                  hint: 'Bachelors degree in Medicine and Surgery...',
                ),
                _buildTextField(label: 'Years of Experience', hint: '10 years'),
                _buildDropdown(
                  label: 'The situation',
                  hint: 'Choose The situation',
                ),
                _buildTextField(
                  label: 'Work Schedule',
                  hint: 'Sunday - Thursday, 8:00 AM - 4:00 PM.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(' Save Doctor'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String label, required String hint}) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            items: const [
              DropdownMenuItem(value: '', child: Text('Choose')),
              DropdownMenuItem(value: 'طب عام', child: Text('طب عام')),
              DropdownMenuItem(value: 'جراحة', child: Text('جراحة')),
              DropdownMenuItem(value: 'أسنان', child: Text('أسنان')),
            ],
            onChanged: (val) {},
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
