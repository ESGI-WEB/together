import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPollAnswered extends StatelessWidget {
  const AllPollAnswered({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(
          width: 150,
          image: AssetImage('assets/images/poll-answered.gif'),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.allPollsAnswered,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.allPollsAnsweredSecondLine,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
            ],
          ),
        )
      ],
    );
  }
}
