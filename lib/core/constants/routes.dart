// lib/core/routes/app_route_names.dart

abstract class AppRoute {
  // Splash
  static const splash = '/splash';

  // Main Layout & Dashboard
  static const MainSecretary = '/';
  static const MainHealth = '/';

  static const dashboard = '/dashboard';

  // Notifications & Profile
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  // Settings & Language

  // Other pages (add more as needed)
  static const appointments = '/appointments';
  static const patients = '/patients';
  static const doctors = '/doctors';
  static const records = '/records';
  static const reports = '/reports';
}
