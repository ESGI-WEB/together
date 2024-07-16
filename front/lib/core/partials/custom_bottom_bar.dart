import 'package:flutter/material.dart';
import 'package:front/chat/chat_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomBar extends StatefulWidget {
  final Widget child;
  final int groupId;

  const CustomBottomBar({
    super.key,
    required this.child,
    required this.groupId,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  JwtData? _authenticatedData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getAuthenticatedData();
  }

  Future<void> _getAuthenticatedData() async {
    var jwtData = await StorageService.readJwtDataFromToken();
    setState(() {
      _authenticatedData = jwtData;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        GroupScreen.navigateTo(context, id: widget.groupId);
        break;
      case 1:
        ChatScreen.navigateTo(context, id: widget.groupId);
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  BottomNavigationBar _buildAppBar(
    BuildContext context,
    JwtData? authenticatedData,
  ) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.event),
          label: AppLocalizations.of(context)!.events,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message),
          label: AppLocalizations.of(context)!.inbox,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildAppBar(context, _authenticatedData),
      body: widget.child,
    );
  }
}
