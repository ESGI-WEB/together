import 'package:flutter/material.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/models/poll_choice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePoll extends StatefulWidget {
  final Function(String question, bool allowMultipleAnswers,
      List<PollChoiceCreateOrEdit> answers)? onSave;
  final void Function()? onClose;
  final bool? saving;
  final Poll? pollToEdit;

  const CreatePoll({
    super.key,
    this.onSave,
    this.onClose,
    this.saving,
    this.pollToEdit,
  });

  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class PollChoiceWithController {
  final TextEditingController controller;
  final PollChoiceCreateOrEdit pollChoice;

  PollChoiceWithController({
    required this.controller,
    required this.pollChoice,
  });
}

class _CreatePollState extends State<CreatePoll> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answersController = <PollChoiceWithController>[
    PollChoiceWithController(
      controller: TextEditingController(),
      pollChoice: PollChoiceCreateOrEdit(choice: ''),
    ),
    PollChoiceWithController(
      controller: TextEditingController(),
      pollChoice: PollChoiceCreateOrEdit(choice: ''),
    ),
  ];
  bool allowMultipleAnswers = false;

  @override
  void initState() {
    super.initState();
    final pollToEdit = widget.pollToEdit;
    final pollChoices = pollToEdit?.choices;
    if (pollToEdit != null && pollChoices != null) {
      _questionController.text = pollToEdit.question;
      _answersController.clear();
      _answersController.addAll(
        pollChoices.map(
          (choice) => PollChoiceWithController(
            controller: TextEditingController(text: choice.choice),
            pollChoice: PollChoiceCreateOrEdit(
              id: choice.id,
              choice: choice.choice,
            ),
          ),
        ),
      );
      allowMultipleAnswers = pollToEdit.isMultiple;
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave?.call(
        _questionController.text,
        allowMultipleAnswers,
        _answersController
            .map((e) => PollChoiceCreateOrEdit(
                  choice: e.controller.text,
                  id: e.pollChoice.id,
                ))
            .toList(),
      );
      reset();
    }
  }

  void reset() {
    setState(() {
      _questionController.clear();
      _answersController.clear();
      _answersController.addAll([
        PollChoiceWithController(
          controller: TextEditingController(),
          pollChoice: PollChoiceCreateOrEdit(choice: ''),
        ),
        PollChoiceWithController(
          controller: TextEditingController(),
          pollChoice: PollChoiceCreateOrEdit(choice: ''),
        ),
      ]);
      allowMultipleAnswers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.pollToEdit == null
                ? AppLocalizations.of(context)!.createAPoll
                : AppLocalizations.of(context)!.editAPoll,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.yourQuestion,
            ),
            controller: _questionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.questionRequired;
              }
              if (value.length < 3) {
                return AppLocalizations.of(context)!.questionMinLength(3);
              }
              if (value.length > 255) {
                return AppLocalizations.of(context)!.questionMaxLength(255);
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.numberOrAnswersPossible(_answersController.length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 250,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < _answersController.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _answersController[i].controller,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.answer,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.answerRequiredOrDelete;
                              }
                              if (value.length > 255) {
                                return AppLocalizations.of(context)!
                                    .answerMaxLength(255);
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: _answersController.length <= 2
                              ? null
                              : () {
                                  setState(() {
                                    _answersController.removeAt(i);
                                  });
                                },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _answersController.add(
                  PollChoiceWithController(
                    controller: TextEditingController(),
                    pollChoice: PollChoiceCreateOrEdit(choice: ''),
                  ),
                );
              });
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addAnAnswer),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(AppLocalizations.of(context)!.allowMultipleAnswers),
            value: allowMultipleAnswers,
            onChanged: (value) {
              setState(() {
                allowMultipleAnswers = value;
              });
            },
            contentPadding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.comfortable,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onClose,
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: widget.saving != true
                    ? const SizedBox()
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                onPressed: widget.saving != true ? submit : null,
                label: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
