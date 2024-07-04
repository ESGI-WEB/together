import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/poll.dart' as poll_model;
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/poll.dart' as poll_model;
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';

class PollLess extends StatelessWidget {
  final poll_model.Poll poll;
  final List<int>? selectedChoices;
  final Function(int choiceId, bool isSelected)? onChoiceSelected;

  const PollLess({
    super.key,
    required this.poll,
    this.selectedChoices,
    this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PollBloc(),
      child: BlocBuilder<PollBloc, PollState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                poll.question,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                poll.isMultiple
                    ? 'Choisissez une ou plusieurs réponses'
                    : 'Choisissez une réponse',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 8,
                    children: [
                      for (var choice in poll.choices ?? [])
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CheckboxListTile(
                            value: selectedChoices?.contains(choice.id) ?? false,
                            onChanged: (value) {
                              onChoiceSelected?.call(choice.id, value ?? true);
                            },
                            checkboxShape: !poll.isMultiple
                                ? const CircleBorder()
                                : const RoundedRectangleBorder(),
                            title: Text(
                              choice.users.length > 0
                                  ? '${choice.choice} (${choice.users.length})'
                                  : choice.choice,
                            ),
                            secondary: AvatarStack(
                              users: choice.users ?? [],
                              displayedAvatars: 3,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
