import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/poll.dart' as poll_model;
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PollField extends StatelessWidget {
  final poll_model.Poll poll;
  final List<int>? selectedChoices;
  final Function(int choiceId, bool isSelected)? onChoiceSelected;
  final Function(String choice)? onChoiceAdded;
  final TextEditingController choiceController = TextEditingController();

  PollField({
    super.key,
    required this.poll,
    this.selectedChoices,
    this.onChoiceSelected,
    this.onChoiceAdded,
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
                    ? AppLocalizations.of(context)!.manyAnswersPossible
                    : AppLocalizations.of(context)!.oneAnswerPossible,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 230,
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
                            value:
                                selectedChoices?.contains(choice.id) ?? false,
                            onChanged: onChoiceSelected != null
                                ? (value) {
                                    onChoiceSelected?.call(
                                        choice.id, value ?? true);
                                  }
                                : null,
                            checkboxShape: !poll.isMultiple
                                ? const CircleBorder()
                                : const RoundedRectangleBorder(),
                            title: Text(choice.choice),
                            secondary: AvatarStack(
                              users: choice.users ?? [],
                              displayedAvatars: 3,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      if (onChoiceAdded != null)
                        TextFormField(
                          controller: choiceController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.addAnAnswer,
                            hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (choiceController.text.isNotEmpty) {
                                  onChoiceAdded?.call(choiceController.text);
                                  choiceController.clear();
                                }
                              },
                            ),
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
