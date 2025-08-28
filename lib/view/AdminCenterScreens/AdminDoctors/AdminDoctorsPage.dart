import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink/controller/AdminRoleControllers/DoctorInviteController%20.dart';
import 'package:medilink/controller/AdminRoleControllers/DoctorsAdminController%20.dart';
import 'package:medilink/controller/AdminRoleControllers/WorkingHoursController%20.dart';
import 'package:medilink/view/AdminCenterScreens/AdminDoctors/DoctorCandidatesDialog%20.dart';

class AdminDoctorsPage extends StatelessWidget {
  AdminDoctorsPage({super.key});
  final AdminDoctorsController controller = Get.put(AdminDoctorsController());
  final DoctorInviteController inviteController = Get.put(
    DoctorInviteController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text(
          "Doctors Management",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Invite + Search
            // 🔹 Title + Invite Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // لليمين
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(DoctorCandidatesDialog());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Invite Doctor"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // نفس لون إضافة السكرتيريا
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Filter + Search (مثل السكرتيرات)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(
                      () => DropdownButton<String>(
                        value:
                            controller
                                .statusFilter
                                .value, // <- ممكن يكون null أو غير مطابق
                        items: const [
                          DropdownMenuItem(
                            value: "all",
                            child: Text("All Status"),
                          ),
                          DropdownMenuItem(
                            value: "active",
                            child: Text("Active"),
                          ),
                          DropdownMenuItem(
                            value: "inactive",
                            child: Text("Inactive"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.statusFilter.value = value;
                            controller.filterDoctors(
                              controller.searchQuery.value,
                              statusFilter: value == "all" ? null : value,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                      controller.filterDoctors(
                        value,
                        statusFilter:
                            controller.statusFilter.value == "all"
                                ? null
                                : controller.statusFilter.value,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Search doctor...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Doctors List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.doctorsList.isEmpty) {
                  return const Center(child: Text('No doctors found'));
                }

                return ListView.builder(
                  itemCount: controller.filteredDoctorsList.length,
                  itemBuilder: (context, index) {
                    final doctor = controller.filteredDoctorsList[index];
                    final user = doctor['user'];
                    final center = doctor['center'];
                    bool isActive = doctor['is_active'] ?? false;
                    String profilePhoto = user['profile_photo'] ?? '';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  profilePhoto.isNotEmpty
                                      ? NetworkImage(
                                        'https://medical.doctorme.site/$profilePhoto',
                                      )
                                      : null,
                              child:
                                  profilePhoto.isEmpty
                                      ? const Icon(Icons.person, size: 30)
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['full_name'] ?? '---',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(user['email'] ?? '---'),
                                  Text('Phone: ${user['phone'] ?? '---'}'),
                                  Text(
                                    'Birthdate: ${user['birthdate'] ?? '---'}',
                                  ),
                                  Text('Gender: ${user['gender'] ?? '---'}'),
                                  Text('Address: ${user['address'] ?? '---'}'),
                                  Text('Center: ${center['name'] ?? '---'}'),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isActive
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color:
                                          isActive
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 🔹 Switch + باقي الأزرار
                                Obx(() {
                                  final isBusy = controller.updatingStatus
                                      .contains(doctor['id']);
                                  final active =
                                      (doctor['is_active'] ?? false) == true;

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AbsorbPointer(
                                        absorbing: isBusy,
                                        child: Switch.adaptive(
                                          value: active,
                                          onChanged: (val) {
                                            controller.setDoctorActiveStatus(
                                              doctor['id'],
                                              val,
                                            );
                                          },
                                        ),
                                      ),
                                      if (isBusy)
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.access_time,
                                          color: Colors.orange,
                                        ),
                                        tooltip: "Working Hours",
                                        onPressed: () {
                                          final workingHoursController =
                                              Get.put(WorkingHoursController());
                                          workingHoursController
                                              .fetchWorkingHours(doctor['id']);
                                          _showWorkingHoursDialog(doctor['id']);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "Remove Doctor",
                                            middleText:
                                                "Are you sure you want to remove this doctor?",
                                            textConfirm: "Yes",
                                            textCancel: "Cancel",
                                            confirmTextColor: Colors.white,
                                            onConfirm: () async {
                                              bool success = await controller
                                                  .unlinkDoctorFromCenter(
                                                    doctor['id'],
                                                  );
                                              if (success) {
                                                Get.back();
                                                Get.snackbar(
                                                  "Success",
                                                  "Doctor removed.",
                                                );
                                                controller.fetchDoctors();
                                              } else {
                                                Get.back();
                                                Get.snackbar(
                                                  "Error",
                                                  "Failed to remove doctor.",
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }),
                              ],
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

  void _deleteDoctor(int doctorId) async {
    bool success = await controller.unlinkDoctorFromCenter(doctorId);
    if (success) {
      Get.snackbar("Success", "Doctor removed from center.");
      controller.fetchDoctors(); // تحديث القائمة فوراً
    } else {
      Get.snackbar("Error", "Failed to remove doctor.");
    }
  }

  // 🔹 Helper لتحويل اسم اليوم لتاريخ ضمن الأسبوع الحالي
  DateTime getDateFromDayName(String dayName) {
    final now = DateTime.now();
    final weekDays = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    int currentWeekday = now.weekday;
    int targetWeekday = weekDays[dayName] ?? 1;
    int diff = targetWeekday - currentWeekday;
    return now.add(Duration(days: diff >= 0 ? diff : diff + 7));
  }

  // 🔹 Dialog عرض ساعات العمل
  void _showWorkingHoursDialog(int doctorId) {
    final workingHoursController = Get.find<WorkingHoursController>();

    Get.defaultDialog(
      title: "Working Hours",
      content: Obx(() {
        if (workingHoursController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 400,
          width: 600,
          child: Column(
            children: [
              if (workingHoursController.workingHours.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No working hours found"),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: workingHoursController.workingHours.length,
                  itemBuilder: (context, index) {
                    final hour = workingHoursController.workingHours[index];
                    return ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(hour['day_of_week']),
                      subtitle: Text(
                        "${hour['start_time']} - ${hour['end_time']}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditWorkingHourDialog(
                                doctorId,
                                hour['id'],
                                hour['day_of_week'],
                                hour['start_time'],
                                hour['end_time'],
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Delete Confirmation",
                                middleText:
                                    "Are you sure you want to delete this working hour?",
                                textConfirm: "Yes",
                                textCancel: "Cancel",
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  workingHoursController.deleteWorkingHour(
                                    hour['id'],
                                    doctorId,
                                  );
                                  Get.back();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Working Hour"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  _showAddWorkingHourDialog(doctorId);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // 🔹 Dialog إضافة دوام جديد
  void _showAddWorkingHourDialog(int doctorId) {
    final workingHoursController = Get.find<WorkingHoursController>();
    final Rx<DateTime?> selectedDate = Rx(null);
    final Rx<TimeOfDay?> startTime = Rx(null);
    final Rx<TimeOfDay?> endTime = Rx(null);

    Get.defaultDialog(
      title: "Add Working Hour",
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate.value == null
                        ? "Select Day"
                        : "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year} (${DateFormat('EEEE').format(selectedDate.value!)})",
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    startTime.value == null
                        ? "Select Start Time"
                        : startTime.value!.format(Get.context!),
                  ),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: Get.context!,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (picked != null) startTime.value = picked;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    endTime.value == null
                        ? "Select End Time"
                        : endTime.value!.format(Get.context!),
                  ),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: Get.context!,
                      initialTime: const TimeOfDay(hour: 17, minute: 0),
                    );
                    if (picked != null) endTime.value = picked;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      textConfirm: "Add",
      textCancel: "Cancel",
      onConfirm: () async {
        if (selectedDate.value == null ||
            startTime.value == null ||
            endTime.value == null) {
          Get.snackbar("Error", "Please select day, start and end time");
          return;
        }

        String dayOfWeek = DateFormat('EEEE').format(selectedDate.value!);
        String start = workingHoursController.formatTimeOfDay(startTime.value!);
        String end = workingHoursController.formatTimeOfDay(endTime.value!);

        await workingHoursController.addWorkingHour(
          doctorId: doctorId,
          dayOfWeek: dayOfWeek,
          startTime: start,
          endTime: end,
        );

        await workingHoursController.fetchWorkingHours(
          doctorId,
        ); // تحديث القائمة فوراً
        Get.back(); // غلق الدالوج بعد التحديث
      },
    );
  }

  // 🔹 Dialog تعديل دوام مع تصحيح مشكلة 1970
  void _showEditWorkingHourDialog(
    int doctorId,
    int workingHourId,
    String currentDay,
    String currentStart,
    String currentEnd,
  ) {
    final workingHoursController = Get.find<WorkingHoursController>();

    // تحويل اليوم الحالي من النص (مثلاً "Monday") لتاريخ صالح
    DateTime now = DateTime.now();
    int weekdayIndex = DateFormat('EEEE').parse(currentDay).weekday;
    DateTime initialDate = now.add(
      Duration(days: (weekdayIndex - now.weekday + 7) % 7),
    );

    // قيم reactive
    final Rx<DateTime> selectedDate = Rx(initialDate);
    final Rx<TimeOfDay> startTime = Rx(
      TimeOfDay(
        hour: int.parse(currentStart.split(":")[0]),
        minute: int.parse(currentStart.split(":")[1]),
      ),
    );
    final Rx<TimeOfDay> endTime = Rx(
      TimeOfDay(
        hour: int.parse(currentEnd.split(":")[0]),
        minute: int.parse(currentEnd.split(":")[1]),
      ),
    );

    Get.defaultDialog(
      title: "Edit Working Hour",
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اليوم
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year} (${DateFormat('EEEE').format(selectedDate.value)})",
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: selectedDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // وقت البداية
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(startTime.value.format(Get.context!)),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: Get.context!,
                      initialTime: startTime.value,
                    );
                    if (picked != null) startTime.value = picked;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // وقت النهاية
              Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(endTime.value.format(Get.context!)),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: Get.context!,
                      initialTime: endTime.value,
                    );
                    if (picked != null) endTime.value = picked;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      textConfirm: "Update",
      textCancel: "Cancel",
      onConfirm: () {
        String dayOfWeek = DateFormat('EEEE').format(selectedDate.value);
        String start = workingHoursController.formatTimeOfDay(startTime.value);
        String end = workingHoursController.formatTimeOfDay(endTime.value);

        workingHoursController.updateWorkingHour(
          workingHourId: workingHourId,
          dayOfWeek: dayOfWeek,
          startTime: start,
          endTime: end,
          doctorId: doctorId,
        );

        Get.back();
      },
    );
  }
}
