import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/add_event_card.dart';
import 'package:front/core/partials/event_card.dart';
import 'package:front/core/partials/next_event_of_group/blocs/next_event_of_group_bloc.dart';
import 'package:front/event/create_event_screen/create_event_screen.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:shimmer/shimmer.dart';

class NextEventOfGroup extends StatelessWidget {
  final int groupId;

  const NextEventOfGroup({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NextEventOfGroupBloc()..add(NextEventOfGroupLoaded(groupId: groupId)),
      child: BlocBuilder<NextEventOfGroupBloc, NextEventOfGroupState>(
        builder: (context, state) {
          if (state.status == NextEventOfGroupStatus.loading) {
            return Shimmer.fromColors(
              baseColor:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              highlightColor: Colors.white,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: const EdgeInsets.all(8.0),
              ),
            );
          } else {
            final event = state.event;
            if (state.status == NextEventOfGroupStatus.error || event == null) {
              return AddEventCard(
                onTap: () {
                  CreateEventScreen.navigateTo(
                    context,
                    groupId: groupId,
                  );
                },
              );
            }

            return Column(
              children: [
                EventCard(
                  event: event,
                  onTap: () {
                    EventScreen.navigateTo(
                      context,
                      groupId: groupId,
                      eventId: event.id,
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
