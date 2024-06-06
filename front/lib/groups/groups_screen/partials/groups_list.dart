import 'package:flutter/cupertino.dart';
import 'package:front/core/models/group.dart';

import 'groups_list_item.dart';

class GroupsList extends StatelessWidget {
  final List<Group> groups;

  const GroupsList({required this.groups, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupsListItem(group: groups[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
