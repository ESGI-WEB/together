import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'package:front/login/login_screen.dart';

import 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2gether',
      theme: AppTheme.theme,
      home: LoginScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
