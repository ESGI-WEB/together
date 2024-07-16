import 'package:flutter/material.dart';
import 'package:front/core/models/group.dart';
import 'package:front/groups/group_screen/group_screen.dart';

class GroupsListItem extends StatelessWidget {
  final Group group;
  final bool showNavigation;

  const GroupsListItem({
    required this.group,
    super.key,
    this.showNavigation = true,
  });

  String _getImageUrl(int id) {
    return 'https://picsum.photos/seed/$id/201';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          GroupScreen.navigateTo(context, id: group.id);  // Pass the bloc to navigateTo
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            _getImageUrl(group.id),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: Icon(
                  Icons.image,
                  color: Colors.grey[400],
                  size: 30,
                ),
              );
            },
          ),
        ),
        title: Text(
          group.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (group.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(group.description ?? ""),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.group, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${group.users?.length ?? 0}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: showNavigation
            ? Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
      ),
    );
  }
}
