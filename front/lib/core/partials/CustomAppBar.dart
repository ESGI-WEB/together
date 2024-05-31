import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/admin/admin_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/login/login_screen.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;

  @override
  State<AppLayout> createState() => _AppLayoutState();

  static PreferredSizeWidget buildAppBar(
      BuildContext context, JwtData? authenticatedData) {
    return AppBar(
      leading: context.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_circle_left_outlined,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        kIsWeb &&
                authenticatedData != null &&
                authenticatedData.role == UserRole.admin.name
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
            StorageService.deleteToken()
                .then((value) => LoginScreen.navigateTo(context));
          },
        ),
      ],
    );
  }
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
      appBar: AppLayout.buildAppBar(context, _authenticatedData),
      body: widget.child,
    );
  }
}
