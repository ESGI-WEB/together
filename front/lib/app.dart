import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'package:front/login/login_screen.dart';
import 'app_routes.dart';
import 'package:front/groups/groups_screen.dart';
import 'groups/group_screen.dart';
import 'groups/create_group_screen.dart';
import 'groups/join_group_screen.dart';

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
