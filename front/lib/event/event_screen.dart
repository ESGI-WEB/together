import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventScreen extends StatefulWidget {
  static const String routeName = '/event';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => !removeHistory);
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
  String? time;
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

      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/events'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(eventData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Succès, traiter la réponse si nécessaire
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Événement créé avec succès !')),
        );
      } else {
        // Erreur, traiter la réponse si nécessaire
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'événement.')),
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
                decoration: InputDecoration(labelText: 'Nom'),
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
                decoration: InputDecoration(labelText: 'Description'),
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
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
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
                decoration: InputDecoration(labelText: 'Heure (HH:MM)'),
                onSaved: (value) {
                  time = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type ID'),
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
                decoration: InputDecoration(labelText: 'Adresse ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une Adresse ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  addressId = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Créer l\'événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
