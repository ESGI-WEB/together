import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/users/partials/users_table.dart';
import 'package:go_router/go_router.dart';

import 'blocs/users_bloc.dart';

class UsersScreen extends StatefulWidget {
  static const String routeName = '/users';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: BlocProvider(
          create: (context) => UsersBloc()..add(UsersDataTableLoaded()),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  UsersTable(
                    onDelete: (eventType) async {
                      log('delete to implement');
                    },
                    onEdit: (eventType) {
                      log('edit to implement');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
