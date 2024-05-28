import 'package:flutter/material.dart';
import 'package:front/groups/groups_list_screen.dart';

import '../../admin/features/features_screen.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const AdminLayout({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              GroupsListScreen.navigateTo(context);
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
