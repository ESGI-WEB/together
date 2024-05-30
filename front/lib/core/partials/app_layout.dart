import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/login/login_screen.dart';
import 'package:front/admin/admin_screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, required this.body, required this.title});

  final Widget body;
  final String title;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
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
      body: widget.body,
    );
  }
}
