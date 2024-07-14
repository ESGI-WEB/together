import 'package:flutter/material.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/models/poll_choice.dart';

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
                ? 'Créer un sondage'
                : 'Modifier le sondage',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Votre question',
            ),
            controller: _questionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer une question';
              }
              if (value.length < 3) {
                return 'La question doit contenir au moins 3 caractères';
              }
              if (value.length > 255) {
                return 'La question doit contenir moins de 255 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text(
            '${_answersController.length} réponses possibles :',
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
                            decoration: const InputDecoration(
                              labelText: 'Réponse',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ou supprimer';
                              }
                              if (value.length > 255) {
                                return 'La réponse doit contenir moins de 255 caractères';
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
            label: const Text('Ajouter une réponse'),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Autoriser plusieurs réponses'),
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
                child: const Text('Annuler'),
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
                label: const Text('Enregistrer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
