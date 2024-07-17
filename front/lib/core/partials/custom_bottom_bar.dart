import 'package:flutter/material.dart';
import 'package:front/chat/chat_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/list_events/list_events_group_screen.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/info/info_group_screen.dart';

class CustomBottomBar extends StatelessWidget {
  final Widget child;
  final int groupId;
  final int selectedIndex;

  const CustomBottomBar({
    super.key,
    required this.child,
    required this.groupId,
    required this.selectedIndex,
  });

  Future<JwtData?> _getAuthenticatedData() async {
    return await StorageService.readJwtDataFromToken();
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        GroupScreen.navigateTo(context, id: groupId);
        break;
      case 1:
        ListEventsGroupScreen.navigateTo(context, id: groupId);
        break;
      case 2:
        ChatScreen.navigateTo(context, id: groupId);
        break;
      case 3:
        InfoGroupScreen.navigateTo(context, id: groupId);
        break;
    }
  }

  BottomNavigationBar _buildAppBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.group),
          label: AppLocalizations.of(context)!.group,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.event),
          label: AppLocalizations.of(context)!.events,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message),
          label: AppLocalizations.of(context)!.inbox,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.info_outline),
          label: AppLocalizations.of(context)!.infos,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JwtData?>(
      future: _getAuthenticatedData(),
      builder: (context, snapshot) {
        return Scaffold(
          bottomNavigationBar: _buildAppBar(context),
          body: child,
        );
      },
    );
  }
}