import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/admin/home/admin_home_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/event_screen.dart';
import 'package:front/login/login_screen.dart';

class Layout extends StatefulWidget {
  const Layout({super.key, required this.body, required this.title});

  final Widget body;
  final String title;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  JwtData? _authenticatedData;

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
                icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.black),
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
          kIsWeb && _authenticatedData != null && _authenticatedData?.role == UserRole.admin.name
              ? IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    AdminHomeScreen.navigateTo(context);
                  },
                )
              : Container(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              StorageService.deleteToken().then((value) =>
                  LoginScreen.navigateTo(context, removeHistory: true));
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
      body: widget.body,
    );
  }
}
