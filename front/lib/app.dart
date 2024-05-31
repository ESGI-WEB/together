import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'package:front/go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: '2gether',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
