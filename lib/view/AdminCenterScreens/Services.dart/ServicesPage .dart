import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ServicesControllers.dart/ServicesController%20.dart';

class ServicesPage extends StatelessWidget {
  ServicesPage({super.key});
  final ServicesController controller = Get.put(ServicesController());

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blueAccent;
    final Color cardColor = Colors.white;
    final Color backgroundColor = const Color(0xFFF5F6F8);
    final TextStyle titleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final TextStyle subtitleStyle = const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    );

    Widget buildServiceList(
      List<Map<String, dynamic>> services,
      bool isCenter,
    ) {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (services.isEmpty) {
        return const Center(child: Text("No services found."));
      } else {
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              color: cardColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(service['name'].toString(), style: titleStyle),
                subtitle: Text(
                  service['description'].toString(),
                  style: subtitleStyle,
                ),
                trailing: Obx(() {
                  bool isAdded = controller.addedServiceIds.contains(
                    service['id'],
                  );
                  return ElevatedButton.icon(
                    onPressed: () {
                      if (isCenter && isAdded) {
                        // ✅ إظهار Dialog تأكيد الحذف
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              width: 300, // عرض ثابت متناسق
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min, // ارتفاع مناسب
                                  children: [
                                    const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Are you sure you want to remove this service?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Get.back(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            minimumSize: const Size(
                                              100,
                                              45,
                                            ), // حجم الزر
                                          ),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            controller
                                                .removeServiceFromCenterApi(
                                                  service['id'],
                                                );
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            minimumSize: const Size(100, 45),
                                          ),
                                          child: const Text("Remove"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (!isAdded) {
                        controller.addServiceToCenterApi(service['id']);
                      }
                    },
                    icon: Icon(
                      isCenter
                          ? Icons.remove
                          : (isAdded ? Icons.check : Icons.add),
                      size: 18,
                    ),
                    label: Text(
                      isCenter ? "Remove" : (isAdded ? "Added" : "Add"),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCenter
                              ? Colors.redAccent
                              : (isAdded ? Colors.grey : primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        );
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const Text(
            "Services",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          bottom: TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [Tab(text: "Catalog"), Tab(text: "Center Services")],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => buildServiceList(controller.catalogServices, false)),
            Obx(() => buildServiceList(controller.centerServices, true)),
          ],
        ),
      ),
    );
  }
}
