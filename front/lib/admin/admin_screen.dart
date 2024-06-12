import 'package:flutter/material.dart';
import 'package:front/admin/charts/monthly_chart.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  static const String routeName = 'admin';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return MonthlyChart();
  }
}
