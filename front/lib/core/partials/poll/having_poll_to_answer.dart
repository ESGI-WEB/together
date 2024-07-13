import 'package:flutter/material.dart';
import 'package:front/core/partials/live_dot.dart';

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
                    '$pollCount ${pollCount > 1 ? 'sondages sont' : 'sondage est'} en cours',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // add a red dot like a registering red light
                  const SizedBox(height: 10),
                  Text(
                    "Les membres de votre groupe ont besoin de votre avis !",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: onPressed,
                    child: const Text("C'est parti"),
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
