import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/admin/admin_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/login/login_screen.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget {
  final bool canPop;
  final Widget child;

  const CustomAppBar({
    super.key,
    required this.child,
    this.canPop = false,
  });

  @override
  State<CustomAppBar> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<CustomAppBar> {
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    JwtData? authenticatedData,
  ) {
    return AppBar(
      centerTitle: true,
      title: Image.asset("assets/images/logo.png", width: 100.0),
      leading: widget.canPop
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      actions: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, _authenticatedData),
      body: widget.child,
    );
  }
}
