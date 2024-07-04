import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/poll.dart' as poll_model;
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';

class Poll extends StatefulWidget {
  final poll_model.Poll poll;
  final List<int>? defaultSelectedChoices;
  final Function(List<int>)? onChoiceChanged;

  const Poll({
    super.key,
    required this.poll,
    this.defaultSelectedChoices,
    this.onChoiceChanged,
  });

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  List<int> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.defaultSelectedChoices ?? [];
  }

  @override
  void didUpdateWidget(Poll oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget != widget) {
    //   setState(() {
    //     selectedChoices = widget.defaultSelectedChoices ?? [];
    //   });
    // }
  }

  void selectChoice(int choiceId, bool isSelected, BuildContext context) {
    setState(() {
      if (isSelected) {
        if (!widget.poll.isMultiple) {
          selectedChoices.clear();
        }
        selectedChoices.add(choiceId);
      } else {
        selectedChoices.remove(choiceId);
      }
    });

    BlocProvider.of<PollBloc>(context).add(PollChoiceSaved(
      pollId: widget.poll.id,
      choiceId: choiceId,
      selected: isSelected,
    ));

    widget.onChoiceChanged?.call(selectedChoices);
  }

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
                widget.poll.question,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                widget.poll.isMultiple
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
                      for (var choice in widget.poll.choices ?? [])
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CheckboxListTile(
                            value: selectedChoices.contains(choice.id),
                            onChanged: (value) {
                              selectChoice(choice.id, value ?? true, context);
                            },
                            checkboxShape: !widget.poll.isMultiple
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
