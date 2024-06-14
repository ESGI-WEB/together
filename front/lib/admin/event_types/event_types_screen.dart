import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/event_types/partials/event_types_form.dart';
import 'package:front/admin/event_types/partials/event_types_table.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/services/api_services.dart';
import 'package:front/core/services/event_type_services.dart';
import 'package:go_router/go_router.dart';

import 'blocs/event_types_bloc.dart';

class EventTypesScreen extends StatefulWidget {
  static const String routeName = '/event-types';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const EventTypesScreen({super.key});

  @override
  State<EventTypesScreen> createState() => _EventTypesScreenState();
}

class _EventTypesScreenState extends State<EventTypesScreen> {
  EventTypeCreateOrEdit? _eventTypeToEditOrCreate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: BlocProvider(
          create: (context) =>
              EventTypesBloc()..add(EventTypesDataTableLoaded()),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_eventTypeToEditOrCreate == null) {
                      _eventTypeToEditOrCreate = EventTypeCreateOrEdit();
                    } else {
                      _eventTypeToEditOrCreate = null;
                    }
                  });
                },
                child: Text(_eventTypeToEditOrCreate != null
                    ? 'Cacher le formulaire'
                    : 'Ajouter un type'),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  if (_eventTypeToEditOrCreate != null)
                    EventTypesForm(
                      eventTypeToEdit: _eventTypeToEditOrCreate,
                      onFormCancel: () {
                        setState(() {
                          _eventTypeToEditOrCreate = null;
                        });
                      },
                    ),
                  EventTypesTable(
                    onEdit: (eventType) async {
                      final response =
                          await ApiServices.get(eventType.image.url);
                      final imageBytes = response.bodyBytes;
                      final image = PlatformFile(
                        name: eventType.image.url,
                        path: eventType.image.url,
                        size: imageBytes.length,
                        bytes: imageBytes,
                      );
                      final eventTypeWithImage = EventTypeCreateOrEdit(
                        id: eventType.id,
                        name: eventType.name,
                        description: eventType.description,
                        image: image,
                      );

                      setState(() {
                        _eventTypeToEditOrCreate = eventTypeWithImage;
                      });
                    },
                    onDelete: (eventType) =>
                        EventTypeServices.deleteEventType(eventType.id),
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
