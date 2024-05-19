import 'package:flutter/material.dart';
import 'group_list_item.dart';

class GroupList extends StatelessWidget {
  final List<Map<String, String>> groups;

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