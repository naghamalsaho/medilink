import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/constants/AppColor.dart';

class Sidebar extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final SidebarController sidebarController = Get.put(SidebarController());

  final List<Map<String, dynamic>> staticItems = [
    {'icon': Icons.dashboard, 'label': 'Dashboard'},
    {'icon': Icons.swap_horiz, 'label': 'Swap'},
    {'icon': Icons.add_circle_outline, 'label': 'Add Liquidity'},
    {'icon': Icons.flash_on, 'label': 'Thor Stake'},
    {'icon': Icons.more_horiz, 'label': 'Pending Liquidity'},
    {'icon': Icons.account_balance_wallet, 'label': 'Your Wallet'},
    {'icon': Icons.cloud, 'label': 'Thornado'},
    {'icon': Icons.bar_chart, 'label': 'Stats'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Thor',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: staticItems.length,
              itemBuilder: (context, index) {
                final item = staticItems[index];
                return Obx(() {
                  final isSelected = sidebarController.selectedIndex.value == index;
                  return GestureDetector(
                    onTap: () => sidebarController.selectedIndex.value = index,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: isSelected
                          ? AppColor.primary
                          : Colors.transparent,
                      child: ListTile(
                        leading: Icon(
                          item['icon'],
                          color: isSelected
                              ? AppColor.accent
                              : Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          item['label'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: isSelected
                                    ? AppColor.accent
                                    : Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Controller to track selected index
class SidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
}
