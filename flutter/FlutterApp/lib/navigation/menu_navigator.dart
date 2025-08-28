import 'package:vision_gate/screens/plans_detail_page.dart';
import 'package:flutter/material.dart';
import '../screens/services_page.dart';
import '../screens/support_page.dart';
import '../screens/settings_page.dart';
import '../screens/location_page.dart';
class AppNavigator {
  // Quick Access
  static void goToServices(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServicesPage()),
    );
  }

  static void goToSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupportPage()),
    );
  }

  static void goToSettings(BuildContext context , String email) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage(email: email)),
    );
  }

  static void goToLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPage()),
    );
  }

  // Plan cards
  static void goToPlanDetails(
    BuildContext context, {
    required String planName,
    required String price,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlansDetailPage(planName: planName, price: price),
      ),
    );
  }
}
