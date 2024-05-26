import 'package:flutter/material.dart';
import 'package:front/core/services/events_services.dart';

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
  int addressId = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final eventData = {
        'name': name,
        'description': description,
        'date': date,
        'time': time,
        'type_id': typeId,
        'address_id': addressId,
      };

      EventsServices.createEvent(
          name, description, date, time, typeId, street, number, city, zip);
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
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date';
                  }
                  return null;
                },
                onSaved: (value) {
                  date = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Heure (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une heure';
                  }
                  return null;
                },
                onSaved: (value) {
                  time = value!;
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
                child: const Text('Créer l\'événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
