import 'package:get/get.dart';
import 'package:medilink/core/constants/routes.dart';
import 'package:medilink/view/screen/DashboardPage.dart';
import 'package:medilink/view/screen/login/SplashScreen.dart';

import 'package:medilink/view/screen/profile/EditProfilePage.dart';
import 'package:medilink/view/screen/profile/ProfilePage.dart';
import 'package:medilink/view/screen/notification/NotificationsPage.dart';
import 'package:medilink/view/screen/AppointmentPage.dart';
import 'package:medilink/view/widget/home/MainLayout.dart';

/// List of all app pages
List<GetPage<dynamic>> appPages = [  
  GetPage(
    name: AppRoute.splash,
    page: () => const SplashScreen(),
    middlewares: [],
  ),
  GetPage(
    name: AppRoute.dashboard,
    page: () => const DashboardPage(),
  ),
  GetPage(
    name: AppRoute.notifications,
    page: () => NotificationPage(),
  ),
  GetPage(
    name: AppRoute.profile,
    page: () => ProfilePage(),
  ),
  GetPage(
    name: AppRoute.editProfile,
    page: () => const EditProfilePage(),
  ),
  GetPage(
    name: AppRoute.appointments,
    page: () => AppointmentsPage(),
  ),
  GetPage(
    name: AppRoute.mainLayout,
    page: () => MainLayout(),
  ),
];
