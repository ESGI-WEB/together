import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/admin/admin_screen.dart';
import 'package:front/chat/chat_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/event_create_screen.dart';
import 'package:front/groups/group_screen.dart';
import 'package:front/login/login_screen.dart';
import 'package:go_router/go_router.dart';

class GroupHomeScreen extends StatefulWidget {
  static const String routeName = 'group';

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'id': id.toString()});
  }

  const GroupHomeScreen({
    super.key,
    required this.groupId,
    required this.title,
  });

  final int groupId;
  final String title;

  @override
  State<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  int _currentIndex = 0;
  JwtData? _authenticatedData;
  late List<Widget> widgets;

  @override
  void initState() {
    super.initState();
    _getAuthenticatedData();

    widgets = <Widget>[
      GroupScreen(id: widget.groupId.toString()),
      ChatScreen(groupId: widget.groupId),
    ];
  }

  Future<void> _getAuthenticatedData() async {
    var jwtData = await StorageService.readJwtDataFromToken();

    setState(() {
      _authenticatedData = jwtData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Événements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messagerie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_circle_left_outlined,
                    color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset("assets/images/logo.png"),
          ),
          kIsWeb &&
                  _authenticatedData != null &&
                  _authenticatedData?.role == UserRole.admin.name
              ? IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    AdminScreen.navigateTo(context);
                  },
                )
              : Container(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              StorageService.deleteToken().then((value) =>
                  LoginScreen.navigateTo(context));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EventScreen.navigateTo(context);
        },
        child: const Icon(Icons.add),
      ),
      body: widgets[_currentIndex],
    );
  }
}
