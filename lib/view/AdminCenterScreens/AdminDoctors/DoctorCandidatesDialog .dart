import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/AdminRoleControllers/DoctorInviteController%20.dart';

class DoctorCandidatesDialog extends StatelessWidget {
  final DoctorInviteController inviteController = Get.find();

  DoctorCandidatesDialog({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    inviteController.fetchDoctorCandidates();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 800,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Invite Doctors",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search doctor...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => searchQuery.value = value,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (inviteController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredDoctors =
                    inviteController.candidatesList.where((doctor) {
                      final name = doctor['full_name']?.toLowerCase() ?? '';
                      final email = doctor['email']?.toLowerCase() ?? '';
                      final query = searchQuery.value.toLowerCase();
                      return name.contains(query) || email.contains(query);
                    }).toList();

                if (filteredDoctors.isEmpty) {
                  return const Center(child: Text("No doctors available"));
                }

                return ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    int userId = doctor['id'] ?? doctor['user_id'];
                    bool isInvited =
                        inviteController.invitedDoctors[userId] == true;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor['full_name'] ?? "---",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Email: ${doctor['email'] ?? "---"}"),
                                  Text("Phone: ${doctor['phone'] ?? "---"}"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isInvited) {
                                  bool ok = await inviteController.inviteDoctor(
                                    userId,
                                  );
                                  if (ok) {
                                    inviteController.invitedDoctors[userId] =
                                        true;
                                    Get.snackbar(
                                      "Invited",
                                      "${doctor['full_name']} has been invited!",
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isInvited ? Colors.grey : Colors.green,
                              ),
                              child: Text(isInvited ? "Invited" : "Invite"),
                            ),
                          ],
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
    );
  }
}
