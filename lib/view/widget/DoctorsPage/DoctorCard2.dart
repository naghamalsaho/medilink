// 📁 components/doctor_card.dart
import 'package:flutter/material.dart';

class DoctorCard2 extends StatelessWidget {
  final String name;
  final String specialty;
  final String qualifications;
  final String experience;
  final String phone;
  final String email;
  final String address;
  final String schedule;
  final int patients;
  final int appointments;
  final bool isActive;

  const DoctorCard2({
    super.key,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.experience,
    required this.phone,
    required this.email,
    required this.address,
    required this.schedule,
    required this.patients,
    required this.appointments,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 700),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {},
                      ),

                      IconButton(
                        icon: const Icon(Icons.visibility_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _iconStat(Icons.person_outline, '$patients patient'),
                      const SizedBox(width: 16),
                      _iconStat(
                        Icons.event_available_outlined,
                        '$appointments Appointment',
                      ),

                      const SizedBox(width: 16),
                      _iconStat(Icons.access_time, '$experience Experience'),
                    ],
                  ),
                ],
              ),

              //   SizedBox(width: 600),
            ],
          ),
          Text(
            specialty,
            style: const TextStyle(color: Colors.blue, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(qualifications),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.email_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(email),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(address),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            " Work Schedule: $schedule",
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _iconStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.purple),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}