import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:medilink/core/localization/changelocal.dart'; // تأكد أنك استوردت هذا

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('choose_language'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('arabic'.tr),
            onTap: () {
              Get.find<LocalController>().changeLanguage("ar");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('english'.tr),
            onTap: () {
              Get.find<LocalController>().changeLanguage("en");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
