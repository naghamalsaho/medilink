import 'package:get/get.dart';
import 'package:medilink/core/constants/routes.dart';
import 'package:medilink/view/SecretaryScreens/AppointmentPage.dart';
import 'package:medilink/view/SecretaryScreens/DashboardPage.dart';
import 'package:medilink/view/SecretaryScreens/Reports/ReportsPage.dart';
import 'package:medilink/view/SecretaryScreens/login/SplashScreen.dart';
import 'package:medilink/view/SecretaryScreens/notification/NotificationsPage.dart';
import 'package:medilink/view/SecretaryScreens/profile/EditProfilePage.dart';
import 'package:medilink/view/SecretaryScreens/profile/ProfilePage.dart';
import 'package:medilink/view/widget/home/MainSecretary.dart';
// import 'view/widget/home/MainHealth.dart';

/// List of all app pages
List<GetPage<dynamic>> appPages = [
  GetPage(
    name: AppRoute.MainSecretary,
    page: () => const SplashScreen(),
    middlewares: [],
  ),
  GetPage(name: AppRoute.dashboard, page: () => const DashboardPage()),
  GetPage(name: AppRoute.notifications, page: () => NotificationPage()),
  GetPage(name: AppRoute.profile, page: () => ProfilePage()),
  GetPage(name: AppRoute.editProfile, page: () => const EditProfilePage()),
  GetPage(name: AppRoute.appointments, page: () => AppointmentsPage()),
  GetPage(name: AppRoute.MainSecretary, page: () => MainSecretary()),

  GetPage(name: AppRoute.reports, page: () => ReportsPage()),
];
