import 'package:flutter/material.dart';

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
                'Vous avez répondu à tous les sondages en cours !',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                "Vous pouvez changer vos réponses ou voir les réponses des autres participants.",
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
