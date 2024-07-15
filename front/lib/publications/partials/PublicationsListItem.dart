import 'package:flutter/material.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/local.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:intl/intl.dart';

class PublicationsListItem extends StatelessWidget {
  final Message publication;
  final User? authenticatedUser;
  final PublicationsBloc publicationsBloc;

  const PublicationsListItem({
    super.key,
    required this.publication,
    this.authenticatedUser,
    required this.publicationsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(user: publication.user),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd(LocaleLanguage.of(context)?.locale)
                          .format(publication.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (authenticatedUser != null &&
                  authenticatedUser!.id == publication.user.id)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context),
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            publication.content,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                  ),
                  const Text('Like'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {},
                  ),
                  const Text('Comment'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController contentController =
        TextEditingController(text: publication.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la publication'),
          content: TextFormField(
            controller: contentController,
            maxLines: null,
            decoration:
                const InputDecoration(hintText: 'Contenu de la publication'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer du contenu';
              } else if (value.length < 10 || value.length > 300) {
                return 'Le contenu doit contenir entre 10 et 300 caractères';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedContent = contentController.text;
                final newPublication = MessageUpdate(
                  content: updatedContent,
                );
                publicationsBloc.add(UpdatePublication(
                    id: publication.id, publication: newPublication));
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
