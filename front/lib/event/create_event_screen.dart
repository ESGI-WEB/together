import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/core/models/address.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/services/event_type_services.dart';
import 'package:front/core/services/events_services.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class CreateEventScreen extends StatefulWidget {
  static const String routeName = 'create_event';

  final int groupId;

  const CreateEventScreen({required this.groupId, super.key});

  static void navigateTo(
    BuildContext context, {
    required int groupId,
  }) {
    context.goNamed(routeName, pathParameters: {'groupId': groupId.toString()});
  }

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String date = '';
  String time = '';
  String street = '';
  String number = '';
  String city = '';
  String zip = '';
  int? typeId;
  int? groupId;
  List<EventType> eventTypes = [];
  EventType? selectedEventType;
  List<Map<String, String>> addressSuggestions = [];

  @override
  void initState() {
    super.initState();
    groupId = widget.groupId;
    _fetchEventTypes();
  }

  Future<void> _fetchEventTypes() async {
    try {
      final eventTypesData = await EventTypeServices.getEventTypes();
      setState(() {
        eventTypes = eventTypesData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Nous n'avons pas réussi à charger les types d'évènements $e")),
      );
    }
  }

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

  Future<void> _fetchAddressSuggestions(String query) async {
    if (query.length < 3) {
      setState(() {
        addressSuggestions = [];
      });
      return;
    }

    final url =
        Uri.parse('http://api-adresse.data.gouv.fr/search?q=$query&limit=5');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        setState(() {
          addressSuggestions = features.map((feature) {
            final properties = feature['properties'] as Map<String, dynamic>;
            return {
              'label': properties['label'] as String,
              'street': properties['street']?.toString() ?? '',
              'city': properties['city']?.toString() ?? '',
              'postcode': properties['postcode']?.toString() ?? '',
              'housenumber': properties['housenumber']?.toString() ?? '',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load addresses: $e')),
      );
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
        typeId: typeId!,
        groupId: groupId!,
        address: AddressCreate(
          street: street,
          number: number,
          city: city,
          zip: zip,
        ),
      );

      try {
        final createdEvent = await EventsServices.createEvent(event);
        EventScreen.navigateTo(
          context,
          groupId: widget.groupId,
          eventId: createdEvent.id,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DropdownButtonFormField<EventType>(
                decoration:
                    const InputDecoration(labelText: "Type d'évènement"),
                items: eventTypes.map((EventType type) {
                  return DropdownMenuItem<EventType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (EventType? value) {
                  setState(() {
                    selectedEventType = value;
                    typeId = value?.id ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Veuillez sélectionner un type d'événement";
                  }
                  return null;
                },
              ),
              Autocomplete<Map<String, String>>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.length < 5) {
                    return const Iterable<Map<String, String>>.empty();
                  }
                  _fetchAddressSuggestions(textEditingValue.text);
                  return addressSuggestions;
                },
                displayStringForOption: (option) => option['label']!,
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'Adresse'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une adresse';
                      }
                      return null;
                    },
                  );
                },
                onSelected: (Map<String, String> selection) {
                  setState(() {
                    street = selection['street']!;
                    number = selection['housenumber']!;
                    city = selection['city']!;
                    zip = selection['postcode']!;
                  });
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
