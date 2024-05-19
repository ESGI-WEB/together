import 'package:flutter/material.dart';

class GroupListItem extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;

  const GroupListItem({
    required this.name,
    required this.description,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 50, // Ajustez la largeur de l'image
        height: 50, // Ajustez la hauteur de l'image
        fit: BoxFit.cover, // Assurez-vous que l'image s'adapte à la taille spécifiée
      ),
      title: Text(name),
      subtitle: Text(description),
    );
  }
}