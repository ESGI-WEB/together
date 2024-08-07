import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:front/core/partials/poll/poll_gateway.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/event/create_event_screen/create_event_screen.dart';
import 'package:front/publication/partials/group_create_publication_bottom_sheet.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:front/publications/partials/publications_list.dart';
import 'package:go_router/go_router.dart';

import 'blocs/group_bloc.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final int id;

  const GroupScreen({super.key, required this.id});

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(
      routeName,
      pathParameters: {'groupId': id.toString()},
    );
  }

  Future<User?> _getAuthenticatedUser() async {
    var jwtData = await StorageService.readJwtDataFromToken();
    if (jwtData != null) {
      return await UserServices.findById(jwtData.id);
    }
    return null;
  }

  void _showBottomSheet(
      BuildContext context, PublicationsBloc publicationsBloc) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: publicationsBloc,
          child: GroupCreatePublicationBottomSheet(
            groupId: id,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getAuthenticatedUser(),
      builder: (context, snapshot) {
        final authenticatedUser = snapshot.data;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GroupBloc()..add(LoadGroup(groupId: id)),
            ),
            BlocProvider(
              create: (context) =>
                  PublicationsBloc()..add(LoadPublications(groupId: id)),
            ),
          ],
          child: Builder(
            builder: (context) {
              return BlocListener<GroupBloc, GroupState>(
                listener: (context, state) {
                  if (state.status == GroupStatus.error) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ??
                              AppLocalizations.of(context)!.errorOccurred),
                        ),
                      );
                    });
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<GroupBloc>().add(LoadGroup(groupId: id));
                    context
                        .read<PublicationsBloc>()
                        .add(LoadPublications(groupId: id));
                  },
                  child: Container(
                    color: Colors.grey[100],
                    child: Builder(
                      builder: (context) {
                        final publicationsBloc =
                            BlocProvider.of<PublicationsBloc>(context);
                        return BlocBuilder<GroupBloc, GroupState>(
                          builder: (context, state) {
                            if (state.status == GroupStatus.loading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (state.status == GroupStatus.error) {
                              return Center(
                                child: Text(state.errorMessage ??
                                    AppLocalizations.of(context)!.errorOccurred),
                              );
                            }

                            final group = state.group;
                            if (group == null) {
                              return Center(
                                child: Text(
                                    AppLocalizations.of(context)!.groupNotFound),
                              );
                            }

                            final isGroupOwner =
                                state.group?.ownerId == state.userData?.id;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _showBottomSheet(context, publicationsBloc),
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        if (authenticatedUser != null)
                                          Avatar(user: authenticatedUser),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            AppLocalizations.of(context)!.news,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: BlocBuilder<PublicationsBloc,
                                          PublicationsState>(
                                      builder: (context, publicationsState) {
                                    return NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                        if (scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent &&
                                            !publicationsState.hasReachedMax) {
                                          context
                                              .read<PublicationsBloc>()
                                              .add(PublicationsLoadMore(id));
                                        }
                                        return false;
                                      },
                                      child: ListView(
                                        padding: const EdgeInsets.all(8.0),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .nextEvent,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  onPressed: () {
                                                    CreateEventScreen.navigateTo(
                                                      context,
                                                      groupId: id,
                                                    );
                                                  },
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ),
                                          NextEventOfGroup(groupId: id),
                                          PollGateway(
                                              id: id,
                                              hasParentEditionRights: isGroupOwner),
                                          const SizedBox(height: 20),
                                          PublicationsList(
                                            groupId: id,
                                            authenticatedUser: authenticatedUser,
                                            publicationsBloc: publicationsBloc,
                                            onAddPublication: () =>
                                                _showBottomSheet(
                                                    context, publicationsBloc),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }
}
