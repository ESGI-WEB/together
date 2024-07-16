import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/users/blocs/users_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/user_services.dart';

class UsersForm extends StatefulWidget {
  final void Function()? onFormCancel;
  final UserCreateOrEdit? initialUser;

  const UsersForm({
    super.key,
    this.onFormCancel,
    this.initialUser,
  });

  @override
  State<UsersForm> createState() => _UsersFormState();
}

class _UsersFormState extends State<UsersForm> {
  final _formKey = GlobalKey<FormState>();
  UserCreateOrEdit _userToEdit = UserCreateOrEdit();

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void didUpdateWidget(UsersForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUser != oldWidget.initialUser) {
      setState(() {
        _initForm();
      });
    }
  }

  void _initForm() {
    if (widget.initialUser != null) {
      _userToEdit = widget.initialUser!;
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _userToEdit = UserCreateOrEdit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state.status == UsersStatus.formSuccess) {
          _resetForm();
        }
      },
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  Text(
                    _userToEdit.id == null
                        ? 'Ajouter un utilisateur'
                        : 'Modifier un utilisateur',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userToEdit.name),
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    enabled: state.status != UsersStatus.formLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      if (value.length < 2) {
                        return 'Le nom doit contenir au moins 2 caractères';
                      }
                      if (value.length > 50) {
                        return 'Le nom doit contenir au maximum 50 caractères';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _userToEdit = _userToEdit.copyWith(name: value);
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: _userToEdit.email),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    enabled: state.status != UsersStatus.formLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un email';
                      }

                      if (!UserServices.emailRegex.hasMatch(value)) {
                        return 'Veuillez saisir un email valide';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      _userToEdit = _userToEdit.copyWith(email: value);
                    },
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userToEdit.biography),
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Biographie',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    enabled: state.status != UsersStatus.formLoading,
                    onChanged: (value) {
                      _userToEdit = _userToEdit.copyWith(biography: value);
                    },
                  ),
                  DropdownButtonFormField<UserRole>(
                    value: _userToEdit.role,
                    decoration: const InputDecoration(
                      labelText: 'Rôle',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    items: UserRole.values
                        .map(
                          (role) => DropdownMenuItem(
                              value: role, child: Text(role.name)),
                        )
                        .toList(),
                    onChanged: (value) {
                      _userToEdit = _userToEdit.copyWith(role: value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez choisir un rôle';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userToEdit.password),
                    decoration: InputDecoration(
                      labelText: _userToEdit.id == null
                          ? 'Mot de passe'
                          : 'Nouveau mot de passe',
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                    ),
                    enabled: state.status != UsersStatus.formLoading,
                    validator: (value) {
                      // If we are editing a user, we don't require a new updated password, so empty password is valid
                      if (_userToEdit.id != null &&
                          (value == null || value.isEmpty)) {
                        return null;
                      }

                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un mot de passe';
                      }

                      if (value.length < 8) {
                        return 'Ajouter au moins 8 caractères';
                      }

                      if (value.length > 72) {
                        return 'Le mot de passe doit contenir au maximum 72 caractères';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      _userToEdit = _userToEdit.copyWith(password: value);
                    },
                  ),
                  if (state.status == UsersStatus.formError)
                    Text(
                      state.formErrorMessage ??
                          "Une erreur est survenue lors de la sauvegarde de l'utilisateur",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onFormCancel,
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 20),
                      if (state.status == UsersStatus.formLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<UsersBloc>(context).add(
                                UserCreatedOrEdited(
                                  id: _userToEdit.id,
                                  user: _userToEdit,
                                ),
                              );
                            }
                          },
                          child: Text(
                            _userToEdit.id == null ? 'Ajouter' : 'Modifier',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
