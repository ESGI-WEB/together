import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = '/createGroup';

  static Future<Map<String, dynamic>?> navigateTo(BuildContext context) {
    return Navigator.of(context).pushNamed<Map<String, dynamic>>(
      routeName,
    );
  }

  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Créer un groupe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle the form submission
                    final newGroup = {
                      "id": DateTime.now().millisecondsSinceEpoch,
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "imagePath": imageController.text,
                    };
                    Navigator.of(context).pop(newGroup);
                  }
                },
                child: const Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
