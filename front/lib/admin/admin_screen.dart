import 'package:flutter/material.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/core/partials/admin_layout.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  static const String routeName = '/admin';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: "Pannel d'administration",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
