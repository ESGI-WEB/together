import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/users/blocs/users_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/local.dart';
import 'package:intl/intl.dart';

class UsersTable extends StatefulWidget {
  final Function(User)? onEdit;
  final Future<void> Function(User)? onDelete;

  const UsersTable({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  List<User> usersDeleting = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state.status == UsersStatus.tableError) {
          return const ErrorOccurred(
            image: Image(
              width: 150,
              image: AssetImage('assets/images/event.gif'),
            ),
            alertMessage: "Oups ! Une erreur est survenue",
            bodyMessage:
                "Nous n'avons pas pu récuperer la liste des utilisateurs",
          );
        }

        final page = state.lastPage;
        final pages = state.pages;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<UsersBloc>().add(UsersDataTableLoaded());
          },
          child: Column(
            children: [
              if (state.users.isEmpty)
                const Text('Aucun utilisateur trouvé')
              else
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Id'),
                    ),
                    DataColumn(
                      label: Text("Date d'inscription"),
                    ),
                    DataColumn(
                      label: Text('Nom'),
                    ),
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('Rôle'),
                    ),
                    DataColumn(
                      label: Text('Biographie'),
                    ),
                    DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: state.users
                      .map(
                        (user) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(user.id.toString()),
                            ),
                            DataCell(
                              Text(DateFormat.yMMMMEEEEd(LocaleLanguage.of(context)?.locale).format(user.createdAt)),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Avatar(user: user),
                                  const SizedBox(width: 10),
                                  Text(user.name),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(user.email),
                            ),
                            DataCell(
                              Text(user.role),
                            ),
                            DataCell(
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: Text(
                                  user.biography ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: <Widget>[
                                  if (widget.onEdit != null)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        widget.onEdit?.call(user);
                                      },
                                    ),
                                  if (widget.onDelete != null)
                                    IconButton(
                                      icon: usersDeleting.contains(user)
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(),
                                            )
                                          : const Icon(Icons.delete),
                                      onPressed: () {
                                        if (usersDeleting.contains(user)) {
                                          return;
                                        }

                                        setState(() {
                                          usersDeleting.add(user);
                                        });

                                        widget.onDelete
                                            ?.call(user)
                                            .then(
                                              (value) =>
                                                  context.read<UsersBloc>().add(
                                                        UsersDataTableLoaded(),
                                                      ),
                                            )
                                            .catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                error is ApiException
                                                    ? error.message
                                                    : 'Une erreur est survenue',
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          );
                                        }).whenComplete(() => setState(() {
                                                  usersDeleting.remove(user);
                                                }));
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              if (pages != null && page != null && page < pages)
                ElevatedButton(
                  onPressed: state.status == UsersStatus.tableLoading ? null : () {
                    context.read<UsersBloc>().add(
                          UsersDataTableLoaded(
                            page: page + 1,
                          ),
                        );
                  },
                  child: const Text('Voir plus'),
                ),
              if (state.status == UsersStatus.tableLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
