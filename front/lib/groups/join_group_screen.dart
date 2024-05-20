import 'package:flutter/material.dart';

class JoinGroupScreen extends StatelessWidget {
  static const String routeName = '/joinGroup';

  static Future<String?> navigateTo(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const JoinGroupScreen(),
      ),
    );
  }

  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejoindre un Groupe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'ID ou nom du groupe',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final groupIdOrName = _controller.text;
                Navigator.of(context).pop(groupIdOrName);
              },
              child: const Text('Rejoindre'),
            ),
          ],
        ),
      ),
    );
  }
}
