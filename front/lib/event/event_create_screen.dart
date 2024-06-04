import 'package:flutter/material.dart';
import 'package:front/core/services/events_services.dart';
import 'package:front/event/event_screen/event_detail_screen.dart';

class EventScreen extends StatefulWidget {
  static const String routeName = '/event';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String date = '';
  String time = '';
  String street = '';
  String number = '';
  String city = '';
  String zip = '';
  int typeId = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        date =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final event = EventCreate(
        name: name,
        description: description,
        date: date,
        time: time,
        typeId: typeId,
        street: street,
        number: number,
        city: city,
        zip: zip,
      );

      try {
        final createdEvent = await EventsServices.createEvent(event);
        // todo à remplacer par un emit lors de l'utilisation de blocs
        EventDetailScreen.navigateTo(context, eventId: createdEvent.id);
      } catch (e) {
        // Handle error (show a snackbar or dialog)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(text: date),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Heure'),
                readOnly: true,
                onTap: () => _selectTime(context),
                controller: TextEditingController(text: time),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une heure';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un Type ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  typeId = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Numéro de rue'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de rue';
                  }
                  return null;
                },
                onSaved: (value) {
                  number = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Rue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une rue';
                  }
                  return null;
                },
                onSaved: (value) {
                  street = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une ville';
                  }
                  return null;
                },
                onSaved: (value) {
                  city = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Code postal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un code postal';
                  }
                  return null;
                },
                onSaved: (value) {
                  zip = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Créer l'évènement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
