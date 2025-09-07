import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/SuperAdminServicesController%20.dart';

class SuperAdminServicesPage extends StatelessWidget {
  final SuperAdminServicesController controller = Get.put(
    SuperAdminServicesController(),
  );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  nameController.clear();
                  descController.clear();
                  Get.defaultDialog(
                    title: 'Create Service',
                    content: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: 'Name'),
                        ),
                        TextField(
                          controller: descController,
                          decoration: InputDecoration(hintText: 'Description'),
                        ),
                      ],
                    ),
                    textConfirm: 'Create',
                    textCancel: 'Cancel',
                    onConfirm: () {
                      controller.createService(
                        nameController.text,
                        descController.text,
                        true,
                      );
                      Get.back();
                    },
                  );
                },
                child: Text('Create New Service'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.servicesList.isEmpty) {
                    return Center(child: Text('No services available'));
                  }
                  return ListView.builder(
                    itemCount: controller.servicesList.length,
                    itemBuilder: (context, index) {
                      var service = controller.servicesList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          title: Text(service['name'] ?? '-'),
                          subtitle: Text(service['description'] ?? '-'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              nameController.text = service['name'] ?? '';
                              descController.text =
                                  service['description'] ?? '';
                              Get.defaultDialog(
                                title: 'Edit Service',
                                content: Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Name',
                                      ),
                                    ),
                                    TextField(
                                      controller: descController,
                                      decoration: InputDecoration(
                                        hintText: 'Description',
                                      ),
                                    ),
                                  ],
                                ),
                                textConfirm: 'Update',
                                textCancel: 'Cancel',
                                onConfirm: () {
                                  controller.updateService(
                                    service['id'],
                                    nameController.text,
                                    descController.text,
                                    true,
                                  );
                                  Get.back();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
