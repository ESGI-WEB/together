import 'package:flutter/material.dart';
import 'group_list_item.dart';

class GroupList extends StatelessWidget {
  final List<Map<String, dynamic>> groups;

  const GroupList({
    required this.groups,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupListItem(
          id: groups[index]["id"]!,
          name: groups[index]["name"]!,
          description: groups[index]["description"]!,
          imagePath: groups[index]["imagePath"]!,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}