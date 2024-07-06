import 'package:flutter/material.dart';

class CreatePoll extends StatefulWidget {
  final Function(
          String question, bool allowMultipleAnswers, List<String> answers)?
      onCreate;
  final void Function()? onClose;
  final bool? saving;

  const CreatePoll({
    super.key,
    this.onCreate,
    this.onClose,
    this.saving,
  });

  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answersController = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ];
  bool allowMultipleAnswers = false;

  void submit() {
    if (_formKey.currentState!.validate()) {
      widget.onCreate?.call(
        _questionController.text,
        allowMultipleAnswers,
        _answersController.map((e) => e.text).toList(),
      );
      reset();
    }
  }

  void reset() {
    setState(() {
      _questionController.clear();
      _answersController.clear();
      _answersController.addAll([
        TextEditingController(),
        TextEditingController(),
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
            'Créer un sondage',
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
                            controller: _answersController[i],
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
                _answersController.add(TextEditingController());
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
                label: const Text('Créer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
