import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoPollCreated extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onSeeClosedPolls;

  const NoPollCreated({
    super.key,
    this.onTap,
    this.onSeeClosedPolls,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            const Image(
              width: 150,
              image: AssetImage('assets/images/poll.gif'),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.createAPoll,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.createAPollDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.createAPoll),
                      ),
                      if (onSeeClosedPolls != null)
                        PopupMenuButton<void>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: onSeeClosedPolls,
                              child: Text(AppLocalizations.of(context)!.seeClosedPolls),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
