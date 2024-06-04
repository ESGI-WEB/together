import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front/core/extensions/string.dart';
import 'package:front/core/models/event.dart';
import 'package:intl/intl.dart';

class DateTile extends StatelessWidget {
  final Event event;

  const DateTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                DateFormat.d(Platform.localeName).format(event.date),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                DateFormat.MMMM(Platform.localeName).format(event.date).capitalize(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
