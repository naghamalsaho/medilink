import 'package:flutter/material.dart';
import 'status_badge.dart';
import 'action_buttons.dart';

class PatientRow extends StatelessWidget {
  final String name, email, phone, age, condition, lastVisit, status;

  const PatientRow({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.condition,
    required this.lastVisit,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  email,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(child: Text("$age years")),
          Expanded(
            child: Row(
              children: [const Icon(Icons.phone, size: 16), Text(" $phone")],
            ),
          ),
          Expanded(child: Text(condition)),
          Expanded(child: Text(lastVisit)),
          Expanded(child: StatusBadge(status: status)),
          SizedBox(width: 60),
          Expanded(
            child: ActionButtons(
              name: name,
              email: email,
              phone: phone,
              gender: "gender",
              age: age,
              status: status,
              condition: condition,
              lastVisit: lastVisit,
            ),
          ),
        ],
      ),
    );
  }
}
