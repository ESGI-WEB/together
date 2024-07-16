import 'package:flutter/material.dart';
import 'package:front/core/partials/live_dot.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HavingPollToAnswer extends StatelessWidget {
  final int pollCount;
  final void Function()? onPressed;

  const HavingPollToAnswer({
    super.key,
    required this.pollCount,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const Image(
              width: 120,
              image: AssetImage('assets/images/poll.gif'),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentPolls(pollCount),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // add a red dot like a registering red light
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.groupMembersNeedYourOpinion,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: onPressed,
                    child: Text(AppLocalizations.of(context)!.letsGo),
                  ),
                ],
              ),
            )
          ],
        ),
        const LiveDot(
          color: Colors.green,
        ),
      ],
    );
  }
}
