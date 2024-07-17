import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                    if (publication.updatedAt != publication.createdAt)
                      Text(
                        "${AppLocalizations.of(context)!.lastModified} ${DateFormat.yMMMMEEEEd(LocaleLanguage.of(context)?.locale).format(publication.updatedAt!)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    else
                      Text(
                        DateFormat.yMMMMEEEEd(
                                LocaleLanguage.of(context)?.locale)
                            .format(publication.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (publication.isPinned ||
                  publication.user.id == authenticatedUser?.id)
                IconButton(
                  icon: Icon(
                    publication.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    color: publication.isPinned
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  onPressed: null,
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
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined),
                    const SizedBox(width: 8.0),
                    Text(AppLocalizations.of(context)!.like),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.comment_outlined),
                    const SizedBox(width: 8.0),
                    Text(AppLocalizations.of(context)!.comment),
                  ],
                ),
              ),
              if (authenticatedUser != null &&
                  authenticatedUser!.id == publication.user.id)
                TextButton(
                  onPressed: () => _showEditDialog(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onBackground,
                    textStyle: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8.0),
                      Text(AppLocalizations.of(context)!.edit),
                    ],
                  ),
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
          title: Text(AppLocalizations.of(context)!.editPublication),
          content: TextFormField(
            controller: contentController,
            maxLines: null,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.publicationContent),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterContent;
              } else if (value.length < 10 || value.length > 300) {
                return AppLocalizations.of(context)!.invalidMessage(300, 10);
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
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
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }
}
