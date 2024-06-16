import 'package:flutter/material.dart';
import 'package:front/admin/dashboard/dasboard_screen.dart';
import 'package:front/admin/event_types/event_types_screen.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/admin/users/users_screen.dart';
import 'package:front/groups/groups_screen/groups_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Theme.of(context).primaryColorLight,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Panel d'administration",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          )),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('Dashboard'),
            onTap: () {
              // close drawer
              Navigator.pop(context);
              DashboardScreen.navigateTo(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_open),
            title: const Text('Fonctionnalités'),
            onTap: () {
              // close drawer
              Navigator.pop(context);
              FeaturesScreen.navigateTo(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Utilisateurs'),
            onTap: () {
              Navigator.pop(context);
              UsersScreen.navigateTo(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Types d'évènements"),
            onTap: () {
              Navigator.pop(context);
              EventTypesScreen.navigateTo(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Retour aux groupes"),
            onTap: () {
              Navigator.pop(context);
              GroupsScreen.navigateTo(context);
            },
          ),
        ],
      ),
    );
  }
}
