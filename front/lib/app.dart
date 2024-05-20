import 'package:flutter/material.dart';
import 'package:front/groups/groups_screen.dart';
import 'groups/group_screen.dart';
import 'groups/create_group_screen.dart'; // Assurez-vous d'importer le nouveau fichier

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2gether',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case GroupScreen.routeName:
            return MaterialPageRoute(
              builder: (context) {
                return GroupScreen(id: args as String);
              },
            );
          case CreateGroupScreen.routeName: // Ajout de la nouvelle route
            return MaterialPageRoute(
              builder: (context) {
                return const CreateGroupScreen();
              },
            );
          case GroupsScreen.routeName:
          default:
            return MaterialPageRoute(
              builder: (context) {
                return const GroupsScreen();
              },
            );
        }
      },
    );
  }
}