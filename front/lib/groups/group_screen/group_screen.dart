import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/groups/group_screen/partials/group_create_publication_bottom_sheet.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:front/publications/partials/PublicationsList.dart';
import 'package:go_router/go_router.dart';

import 'blocs/group_bloc.dart';

class GroupScreen extends StatefulWidget {
  static const String routeName = 'group';

  final int id;

  const GroupScreen({super.key, required this.id});

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(
      routeName,
      pathParameters: {'groupId': id.toString()},
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
          create: (context) => GroupBloc()..add(LoadGroup(groupId: widget.id)),
        ),
        BlocProvider(
          create: (context) =>
          PublicationsBloc()..add(LoadPublications(groupId: widget.id)),
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
                    if (_authenticatedUser != null) Avatar(user: _authenticatedUser!),
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
            NextEventOfGroup(groupId: widget.id),
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state.status == GroupStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == GroupStatus.error) {
                  return Center(child: Text(state.errorMessage ?? 'Erreur inconnue'));
                }

                final group = state.group;
                if (group == null) {
                  return const Center(child: Text('Groupe introuvable'));
                }

                return PublicationsList(
                  groupId: widget.id,
                  authenticatedUser: _authenticatedUser,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}