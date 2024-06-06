import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/event_types/blocs/event_types_bloc.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/partials/error_occurred.dart';

class EventTypesTable extends StatelessWidget {
  const EventTypesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventTypesBloc, EventTypesState>(
      builder: (context, state) {
        if (state.status == EventTypesStatus.tableLoading && state.types == null) {
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
            if (types == null)
              const Text('Aucun type d\'évènement trouvé')
            else
              DataTable(
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
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Navigate to Edit Event Type screen
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // Delete Event Type
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
            if (state.status == EventTypesStatus.tableLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
