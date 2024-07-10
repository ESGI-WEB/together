import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/groups/group_screen/partials/group_create_publication_bottom_sheet.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/group_screen_bloc.dart';

class GroupScreen extends StatefulWidget {
  static const String routeName = 'group';

  final int id;
  final PublicationsBloc publicationsBloc;

  const GroupScreen(
      {super.key, required this.id, required this.publicationsBloc});

  static void navigateTo(BuildContext context,
      {required int id, required PublicationsBloc publicationsBloc}) {
    context.goNamed(
      routeName,
      pathParameters: {'groupId': id.toString()},
      extra: publicationsBloc,
    );
  }

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  User? _authenticatedUser;

  @override
  void initState() {
    super.initState();
    _getAuthenticatedUser();
    widget.publicationsBloc.add(PublicationsLoaded(widget.id));
  }

  Future<void> _getAuthenticatedUser() async {
    var jwtData = await StorageService.readJwtDataFromToken();
    if (jwtData != null) {
      var user = await UserServices.findById(jwtData.id);
      setState(() {
        _authenticatedUser = user;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GroupCreatePublicationBottomSheet(groupId: widget.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GroupScreenBloc()..add(LoadGroupScreen(groupId: widget.id)),
        ),
        BlocProvider.value(
          value: widget.publicationsBloc,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            InkWell(
              onTap: () => _showBottomSheet(context),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_authenticatedUser != null)
                      Avatar(user: _authenticatedUser!),
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
            NextEventOfGroup(
              groupId: widget.id,
            ),
            BlocBuilder<GroupScreenBloc, GroupScreenState>(
              builder: (context, state) {
                if (state.status == GroupScreenStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == GroupScreenStatus.error) {
                  return Center(
                      child: Text(state.errorMessage ?? 'Erreur inconnue'));
                }

                final group = state.group;
                if (group == null) {
                  return const Center(child: Text('Groupe introuvable'));
                }

                return BlocBuilder<PublicationsBloc, PublicationsState>(
                  builder: (context, state) {
                    if (state.status == PublicationsStatus.loading &&
                        state.publications == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == PublicationsStatus.error) {
                      return Center(
                          child: Text(state.errorMessage ?? 'Erreur inconnue'));
                    }

                    final publications = state.publications;
                    if (publications == null || publications.isEmpty) {
                      return const Center(
                          child: Text('Aucune publication disponible'));
                    }

                    return Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              !state.hasReachedMax) {
                            context
                                .read<PublicationsBloc>()
                                .add(PublicationsLoadMore(widget.id));
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: publications.length +
                              (state.status == PublicationsStatus.loadingMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index == publications.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return ListTile(
                                title: Text(publications[index].content),
                                subtitle: Text(publications[index].content),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}