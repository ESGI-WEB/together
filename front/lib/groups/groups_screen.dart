import 'package:flutter/material.dart';
import 'goup_button.dart';
import 'group_list.dart';

// Liste de groupes (données en dur pour l'exemple)
final List<Map<String, dynamic>> groups = [
  {
    "id": 1,
    "name": "Groupe 1",
    "description": "Description du groupe 1 Description du groupe 1Description du groupe 1Description du groupe 1",
    "imagePath": "lib/core/images/group1.jpg", // Remplacez cela par le chemin d'accès réel de votre image
  },
  {
    "id" : 2,
    "name": "Groupe 1",
    "description": "Description du groupe 1",
    "imagePath": "lib/core/images/group1.jpg", // Remplacez cela par le chemin d'accès réel de votre image
  },
  // Ajoutez autant de groupes que vous le souhaitez
];

class GroupsScreen extends StatelessWidget {
  static const String routeName = '/groups';

  static Future<void> navigateTo(BuildContext context) {
    return Navigator.of(context).pushNamed(routeName);
  }
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groupes')),
      body: Stack(
        children: [
          Positioned.fill(
            child: GroupList(groups: groups),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GroupButton(
                  text: 'Créer',
                  icon: Icons.add,
                  onPressed: () {
                    // Action à effectuer lors du clic sur le bouton "Créer"
                  },
                ),
                const SizedBox(width: 10.0), // Espacement entre les boutons
                GroupButton(
                  text: 'Rejoindre',
                  icon: Icons.person_add,
                  onPressed: () {
                    // Action à effectuer lors du clic sur le bouton "Rejoindre"
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
