import 'package:flutter/material.dart';
import 'group_screen.dart';

class GroupListItem extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  const GroupListItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        GroupScreen.navigateTo(context, id: id.toString());
      },
      leading: Image.asset(
        imagePath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      title: Text(name),
      subtitle: Text(description),
    );
  }
}