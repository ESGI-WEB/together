import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/publication/create_publication_screen/blocs/create_publication_bloc.dart';
import 'package:front/publication/create_publication_screen/blocs/create_publication_event.dart';
import 'package:front/publication/create_publication_screen/blocs/create_publication_state.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupCreatePublicationBottomSheet extends StatelessWidget {
  final int groupId;

  const GroupCreatePublicationBottomSheet({required this.groupId, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocProvider(
        create: (context) => CreatePublicationBloc(),
        child: BlocListener<CreatePublicationBloc, CreatePublicationState>(
          listener: (context, state) {
            if (state.status == CreatePublicationStatus.success) {
              Navigator.pop(context);
              context
                  .read<PublicationsBloc>()
                  .add(PublicationAdded(state.newPublication!));
            } else if (state.status == CreatePublicationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage ?? AppLocalizations.of(context)!.errorOccurred)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CreatePublicationForm(groupId: groupId),
          ),
        ),
      ),
    );
  }
}

class CreatePublicationForm extends StatefulWidget {
  final int groupId;

  const CreatePublicationForm({required this.groupId, super.key});

  @override
  _CreatePublicationFormState createState() => _CreatePublicationFormState();
}

class _CreatePublicationFormState extends State<CreatePublicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isPinned = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.addPublication,
                style: Theme.of(context).textTheme.headline6,
              ),
              IconButton(
                icon: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: _isPinned
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPinned = !_isPinned;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.messageContent,
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
            maxLines: 5,
            minLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterContent;
              } else if (value.length < 10 || value.length > 300) {
                return AppLocalizations.of(context)!.invalidMessage(10, 300);
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                final newPublication = {
                  "content": _contentController.text,
                  "event_id": null,
                  "group_id": widget.groupId,
                  "is_pinned": _isPinned,
                };
                context
                    .read<CreatePublicationBloc>()
                    .add(CreatePublicationSubmitted(newPublication));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.publish),
          ),
        ],
      ),
    );
  }
}
