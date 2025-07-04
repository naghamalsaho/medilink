import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}

class SectionSubtitle extends StatelessWidget {
  final String text;
  const SectionSubtitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

class InfoBoxText extends StatelessWidget {
  final String text;
  const InfoBoxText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                                 height: 110,
  width: 500,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.blueGrey),
      ),
    );
  }
}