import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/event_types/partials/event_types_form.dart';
import 'package:front/admin/event_types/partials/event_types_table.dart';
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
  bool _showForm = false;

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
                    _showForm = !_showForm;
                  });
                },
                child: Text(
                    _showForm ? 'Cacher le formulaire' : 'Ajouter un type'),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  const EventTypesTable(),
                  if (_showForm)
                    EventTypesForm(
                      onFormCancel: () {
                        setState(() {
                          _showForm = false;
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
