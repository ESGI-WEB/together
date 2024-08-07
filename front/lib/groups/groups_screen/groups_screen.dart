import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/core/partials/custom_icon_button.dart';
import 'package:front/core/partials/event_card.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:front/event/list_events/list_events_user_screen.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/groups_screen/partials/groups_list_item.dart';
import 'package:front/groups/join_group_screen/join_group_screen.dart';
import 'package:go_router/go_router.dart';

import 'blocs/groups_bloc.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = 'groups';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsBloc()..add(GroupsLoaded()),
      child: Builder(
        builder: (context) => BlocListener<GroupsBloc, GroupsState>(
          listener: (context, state) {
            if (state.status == GroupsStatus.error) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ??
                        AppLocalizations.of(context)!.unableToLoadGroups),
                  ),
                );
              });
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<GroupsBloc>().add(GroupsLoaded());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GroupsBloc, GroupsState>(
                    builder: (context, state) {
                      if (state.status == GroupsStatus.loading &&
                          state.groups == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.groups != null && state.groups!.isNotEmpty) {
                        return Expanded(
                          child: ListView(
                            children: [
                              if (state.nextEventOfUser != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .nextEvent,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              ListEventsUserScreen.navigateTo(
                                                context,
                                              );
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .seeMore,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    EventCard(
                                      event: state.nextEventOfUser!,
                                      onTap: () {
                                        EventScreen.navigateTo(
                                          context,
                                          groupId:
                                              state.nextEventOfUser!.groupId,
                                          eventId: state.nextEventOfUser!.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  AppLocalizations.of(context)!.groups,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 8),
                              NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      !state.hasReachedMax) {
                                    context
                                        .read<GroupsBloc>()
                                        .add(GroupsLoadMore());
                                  }
                                  return false;
                                },
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.groups!.length +
                                      (state.status == GroupsStatus.loadingMore
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index == state.groups!.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return GroupsListItem(
                                          group: state.groups![index]);
                                    }
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state.status == GroupsStatus.success &&
                          (state.groups == null || state.groups!.isEmpty)) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                width: 150,
                                image: AssetImage('assets/images/poll.gif'),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.noGroupAvailable,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.createOrJoinGroup,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () {
                                  final groupsBloc = context.read<GroupsBloc>();
                                  CreateGroupScreen.navigateTo(
                                      context, groupsBloc);
                                },
                                icon: const Icon(Icons.add),
                                label:
                                    Text(AppLocalizations.of(context)!.create),
                              ),
                            ],
                          ),
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        icon: Icons.add,
                        label: AppLocalizations.of(context)!.create,
                        onPressed: () {
                          final groupsBloc = context.read<GroupsBloc>();
                          CreateGroupScreen.navigateTo(context, groupsBloc);
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomIconButton(
                        icon: Icons.group_add,
                        label: AppLocalizations.of(context)!.join,
                        onPressed: () {
                          final groupsScreenBloc = context.read<GroupsBloc>();
                          JoinGroupScreen.navigateTo(context, groupsScreenBloc);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
