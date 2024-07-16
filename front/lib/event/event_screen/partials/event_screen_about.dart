import 'package:flutter/material.dart';
import 'package:front/core/models/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventScreenAbout extends StatelessWidget {
  final Event event;

  const EventScreenAbout({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.eventAbout,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          event.description,
        ),
      ],
    );
  }
}
