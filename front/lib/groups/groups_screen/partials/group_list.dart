import 'package:flutter/cupertino.dart';
import 'package:front/core/models/group.dart';

import 'group_list_item.dart';

class GroupList extends StatelessWidget {
  final List<Group> groups;

  const GroupList({required this.groups, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupListItem(group: groups[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
