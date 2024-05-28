import 'package:flutter/material.dart';
import '../../core/partials/admin-layout.dart';

class FeaturesScreen extends StatelessWidget {
  static const String routeName = '/features';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Fonctionnalités',
      body: Center(
        child: Text('Fonctionnalités'),
      ),
    );
  }
}
