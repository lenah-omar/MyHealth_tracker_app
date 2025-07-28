import 'package:flutter/material.dart';
import 'package:myhealth_tracker/presentation/views/HealthTipsPage.dart';
import 'package:myhealth_tracker/presentation/views/RemindersPage.dart';
import 'package:myhealth_tracker/presentation/views/SleepTrackerPage.dart';
import 'package:myhealth_tracker/presentation/views/home_page.dart';
import 'package:myhealth_tracker/presentation/views/login_page.dart';
import 'package:myhealth_tracker/presentation/views/register_page.dart';
import 'package:myhealth_tracker/presentation/views/upload_page.dart';
import 'package:myhealth_tracker/presentation/views/settings_page.dart';
import 'package:myhealth_tracker/presentation/views/weight_tracker_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/upload':
        return MaterialPageRoute(builder: (_) => const UploadPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case '/weight_tracker':
        return MaterialPageRoute(builder: (_) => const WeightTrackerPage());
      case '/sleep_tracker':
        return MaterialPageRoute(builder: (_) => const SleepTrackerPage());
      case '/reminders':
        return MaterialPageRoute(builder: (_) => const RemindersPage());
      case '/health_tips':
        return MaterialPageRoute(builder: (_) => const HealthTipsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page not found")),
          ),
        );
    }
  }
}
