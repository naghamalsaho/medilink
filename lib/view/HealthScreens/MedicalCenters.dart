// 📁 DoctorsPage.dart
import 'package:flutter/material.dart';
import 'package:medilink/view/widget/DoctorsPage/AddDoctorDialog.dart';
import 'package:medilink/view/widget/DoctorsPage/DoctorCard.dart';
import 'package:medilink/view/widget/DoctorsPage/DoctorHeader.dart';

class MedicalCenters extends StatelessWidget {
  const MedicalCenters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorHeadr(),
              SizedBox(height: 16),

              // _buildStatsRow(),
              // const SizedBox(height: 24),
              _buildFilters(),
              const SizedBox(height: 24),
              const Text(
                'List of doctors',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              const DoctorCard(
                name: 'D.sami',
                specialty: 'General Medicine',
                qualifications:
                    'Bachelors in Medicine and Surgery, Masters in General Medicine',
                experience: '15 years',
                phone: '0012345678',
                email: 'sami.ahmad@clinic.com',
                address: 'Syria,Homs',
                schedule: 'Sunday - Thursday, 8:00 AM - 4:00 PM.',
                patients: 245,
                appointments: 89,
                isActive: true,
              ),
              const DoctorCard(
                name: 'D.sami',
                specialty: 'General Medicine',
                qualifications:
                    'Bachelors in Medicine and Surgery, Masters in General Medicine',
                experience: '15 years',
                phone: '0012345678',
                email: 'sami.ahmad@clinic.com',
                address: 'Syria,Homs',
                schedule: 'Sunday - Thursday, 8:00 AM - 4:00 PM.',
                patients: 245,
                appointments: 89,
                isActive: true,
              ),
              SizedBox(height: 14),
              const DoctorCard(
                name: 'D.sami',
                specialty: 'General Medicine',
                qualifications:
                    'Bachelors in Medicine and Surgery, Masters in General Medicine',
                experience: '15 years',
                phone: '0012345678',
                email: 'sami.ahmad@clinic.com',
                address: 'Syria,Homs',
                schedule: 'Sunday - Thursday, 8:00 AM - 4:00 PM.',
                patients: 245,
                appointments: 89,
                isActive: true,
              ),
              // بإمكانك تكرار DoctorCard أو استخدام ListView.builder
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctors Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Management and monitoring of doctors data and specialties, ',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed:
              () => showDialog(
                context: context,
                builder: (_) => const AddDoctorDialog(),
              ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add a new doctor'),
        ),
      ],
    );
  }

  // Widget _buildStatsRow() {
  //   // return Row(
  //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //   children: const [
  //   //     StatCard(label: 'إجمالي الأطباء', value: '4', color: Colors.blue),
  //   //     StatCard(label: 'أطباء نشطين', value: '3', color: Colors.green),
  //   //     StatCard(label: 'إجمالي المرضى', value: '788', color: Colors.purple),
  //   //     StatCard(label: 'إجمالي المواعيد', value: '287', color: Colors.orange),
  //   //   ],
  //   // );
  // }

  Widget _buildFilters() {
    return Row(
      children: [
        // ElevatedButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(Icons.filter_alt_outlined),
        //   label: const Text('فلترة متقدمة'),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.grey.shade200,
        //     foregroundColor: Colors.black87,
        //   ),
        // ),
        // const SizedBox(width: 16),
        DropdownButton<String>(
          value: 'all specialties',
          items: const [
            DropdownMenuItem(
              value: 'all specialties',
              child: Text('all specialties'),
            ),
            DropdownMenuItem(
              value: 'General Medicine',
              child: Text('General Medicine'),
            ),
            DropdownMenuItem(value: 'Surgery', child: Text('Surgery')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText:
                  'Searching for a doctor by name, specialty, or phone number...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
