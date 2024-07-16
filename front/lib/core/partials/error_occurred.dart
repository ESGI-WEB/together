import 'package:flutter/material.dart';

class ErrorOccurred extends StatelessWidget {
  final Widget image;
  final String alertMessage;
  final String bodyMessage;
  final void Function()? onBackButtonPressed;
  final void Function()? onHomeButtonPressed;

  const ErrorOccurred({
    super.key,
    required this.image,
    this.alertMessage =
        "Oups ! Il n'est pas possible de faire ça pour le moment.",
    this.bodyMessage =
        "Veuillez revenir plus tard. Cette fonctionnalité n'est pas disponible actuellement.",
    this.onBackButtonPressed,
    this.onHomeButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(20),
              child: Text(
                alertMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              bodyMessage,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onBackButtonPressed ?? () {
                Navigator.of(context).pop();
              },
              child: const Text('Retour'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onHomeButtonPressed ?? () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Retour à l'accueil"),
            )
          ],
        ),
      ),
    );
  }
}
