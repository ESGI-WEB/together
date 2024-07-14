import 'package:flutter/material.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/local.dart';
import 'package:intl/intl.dart';

class PublicationsListItem extends StatelessWidget {
  final Message publication;
  final User? authenticatedUser;

  const PublicationsListItem({
    super.key,
    required this.publication,
    this.authenticatedUser,
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
