import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/users/partials/users_form.dart';
import 'package:front/admin/users/partials/users_table.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/user_services.dart';
import 'package:go_router/go_router.dart';

import 'blocs/users_bloc.dart';

class UsersScreen extends StatefulWidget {
  static const String routeName = 'users';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _showUserForm = false;
  UserCreateOrEdit? _userCreateOrEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: BlocProvider(
          create: (context) => UsersBloc()..add(UsersDataTableLoaded()),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userCreateOrEdit = null;
                    _showUserForm = !_showUserForm;
                  });
                },
                child: Text(_showUserForm
                    ? 'Cacher le formulaire'
                    : 'Ajouter un utilisateur'),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  if (_showUserForm)
                    UsersForm(
                      initialUser: _userCreateOrEdit ?? UserCreateOrEdit(),
                      onFormCancel: () {
                        setState(() {
                          _userCreateOrEdit = null;
                          _showUserForm = false;
                        });
                      },
                    ),
                  UsersTable(
                    onDelete: (user) => UserServices.deleteUser(user.id),
                    onEdit: (user) {
                      setState(() {
                        _showUserForm = true;
                        _userCreateOrEdit = UserCreateOrEdit(
                          id: user.id,
                          name: user.name,
                          email: user.email,
                          biography: user.biography,
                          role: user.role,
                        );
                      });
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
