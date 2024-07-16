import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:front/core/partials/poll/poll_gateway.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/publication/partials/group_create_publication_bottom_sheet.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:front/publications/partials/PublicationsList.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              final publicationsBloc =
                  BlocProvider.of<PublicationsBloc>(context);
              return Scaffold(
                backgroundColor: Colors.grey[300],
                body: Column(
                  children: [
                    InkWell(
                      onTap: () => _showBottomSheet(context, publicationsBloc),
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
                                "Quoi de neuf ?",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<GroupBloc, GroupState>(
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

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                PollGateway(
                                  id: id,
                                  hasParentEditionRights: isGroupOwner,
                                ),
                                NextEventOfGroup(
                                  groupId: id,
                                ),
                                PublicationsList(
                                  groupId: id,
                                  authenticatedUser: authenticatedUser,
                                  publicationsBloc: publicationsBloc,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
