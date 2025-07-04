import 'package:flutter/material.dart';
import 'package:medilink/core/functions/validinput.dart';

class Customtextformauth extends StatelessWidget {
  final String labeltext;
  final TextEditingController? mycontroller;
  final String? Function(String?)? valid;
  final IconData iconData;
  final String type;
  const Customtextformauth({
    Key? Key,

    required this.labeltext,
    required this.iconData,
    required this.mycontroller,
    required this.valid,
    required this.type,
  }) : super(key: Key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        return validInput(val!, 5, 100, type);
      },
      controller: mycontroller,
      decoration: InputDecoration(
        labelText: labeltext,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

}
