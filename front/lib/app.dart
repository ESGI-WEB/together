import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2gether',
      theme: AppTheme.theme,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
