import 'package:flutter/material.dart';
import 'package:front/event/list_events/list_events.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListEventsGroupScreen extends StatelessWidget {
  static const String routeName = 'list-group-next-event';

  static void navigateTo(
    BuildContext context, {
    required int id,
  }) {
    context.goNamed(
      routeName,
      pathParameters: {'groupId': id.toString()},
    );
  }

  final int id;

  const ListEventsGroupScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.groupEvents,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: ListEvents(
              groupId: id,
            ),
          ),
        ],
      ),
    );
  }
}
