import 'package:flutter/material.dart';
import 'package:front/event/list_events/list_events.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListEventsUserScreen extends StatelessWidget {
  static const String routeName = 'list-user-next-event';

  static void navigateTo(
    BuildContext context,
  ) {
    context.goNamed(
      routeName,
    );
  }

  const ListEventsUserScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.yourNextParticipatingEvents,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Expanded(
            child: ListEvents(),
          ),
        ],
      ),
    );
  }
}
