import 'package:flutter/material.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/core/partials/admin-layout.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const String routeName = '/admin';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: "Pannel d'administration",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text(
                'View Features',
              ),
              onPressed: () {
                FeaturesScreen.navigateTo(context);
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text(
                'View Users',
              ),
              onPressed: () {
                // Navigate to Users screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
