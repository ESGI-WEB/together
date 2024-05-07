import 'package:flutter/material.dart';
import 'package:front/core/red_square.dart';
import 'package:front/home/groups_screen.dart';

import 'core/layout.dart';
import 'home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const GroupScreen(),
        "/group": (context) => Layout(
              body: const HomeScreen(),
              title:
                  "Groupe: ${(ModalRoute.of(context)?.settings.arguments as ScreenArguments).groupId}",
            ),
      },
    );
  }
}
