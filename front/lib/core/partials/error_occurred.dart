import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorOccurred extends StatelessWidget {
  final Widget image;
  final String? alertMessage;
  final String? bodyMessage;
  final void Function()? onBackButtonPressed;
  final void Function()? onHomeButtonPressed;

  const ErrorOccurred({
    super.key,
    required this.image,
    this.alertMessage,
    this.bodyMessage,
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
                alertMessage ?? AppLocalizations.of(context)!.oopsCantDoThat,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              bodyMessage ?? AppLocalizations.of(context)!.tryFeatureLater,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onBackButtonPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
              child: Text(AppLocalizations.of(context)!.back),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onHomeButtonPressed ??
                  () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
              child: Text(AppLocalizations.of(context)!.backToHome),
            )
          ],
        ),
      ),
    );
  }
}
