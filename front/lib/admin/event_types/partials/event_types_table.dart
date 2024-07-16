import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/event_types/blocs/event_types_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/partials/error_occurred.dart';

class EventTypesTable extends StatefulWidget {
  final Function(EventType)? onEdit;
  final Future<void> Function(EventType)? onDelete;

  const EventTypesTable({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<EventTypesTable> createState() => _EventTypesTableState();
}

class _EventTypesTableState extends State<EventTypesTable> {
  List<EventType> typesDeleting = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventTypesBloc, EventTypesState>(
      builder: (context, state) {
        if (state.status == EventTypesStatus.tableLoading &&
            state.types == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == EventTypesStatus.tableError) {
          return const ErrorOccurred(
            image: Image(
              width: 150,
              image: AssetImage('assets/images/event.gif'),
            ),
            alertMessage: "Oups ! Une erreur est survenue",
            bodyMessage:
                "Nous n'avons pas pu récuperer la liste des types d'évènement",
          );
        }

        final List<EventType>? types = state.types;
        return Column(
          children: [
            if (types == null || types.isEmpty)
              const Text('Aucun type d\'évènement trouvé')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Id'),
                    ),
                    DataColumn(
                      label: Text('Nom'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                    DataColumn(
                      label: Text('Image'),
                    ),
                    DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: types
                      .map(
                        (type) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(type.id.toString()),
                            ),
                            DataCell(
                              Text(type.name),
                            ),
                            DataCell(
                              Text(type.description),
                            ),
                            DataCell(
                              Image(
                                image: type.image,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            DataCell(
                              Row(
                                children: <Widget>[
                                  if (widget.onEdit != null)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        widget.onEdit?.call(type);
                                      },
                                    ),
                                  if (widget.onDelete != null)
                                    IconButton(
                                      icon: typesDeleting.contains(type)
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(),
                                            )
                                          : const Icon(Icons.delete),
                                      onPressed: () {
                                        if (typesDeleting.contains(type)) {
                                          return;
                                        }

                                        setState(() {
                                          typesDeleting.add(type);
                                        });

                                        widget.onDelete
                                            ?.call(type)
                                            .then(
                                              (value) => context
                                                  .read<EventTypesBloc>()
                                                  .add(
                                                    EventTypesDataTableLoaded(),
                                                  ),
                                            )
                                            .catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                error is ApiException &&
                                                        error.message.isNotEmpty
                                                    ? error.message
                                                    : 'Une erreur est survenue',
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          );
                                        }).whenComplete(() => setState(() {
                                                  typesDeleting.remove(type);
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
              ),
            if (state.status == EventTypesStatus.tableLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
