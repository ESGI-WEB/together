import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatureDisabledPage extends StatelessWidget {
  const FeatureDisabledPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/503.svg',
              height: 200,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.redAccent.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Oups ! Il n'est pas possible de faire ça pour le moment.",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Veuillez revenir plus tard. Cette fonctionnalité n'est pas disponible actuellement.",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Retour'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
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
