import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front/core/models/address.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/date_tile.dart';
import 'package:front/core/services/api_services.dart';
import 'package:front/local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventScreenHeader extends StatelessWidget {
  final Event event;

  const EventScreenHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Address? address = event.address;
    final User? organizer = event.organizer;

    final NetworkImage image = event.type?.image ??
        NetworkImage("${ApiServices.baseUrl}/storage/images/types/default.png");

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        if (organizer != null)
                          Text(
                            AppLocalizations.of(context)!.fromNameTheDay(
                              "${DateFormat.yMd(LocaleLanguage.of(context)?.locale).format(event.date)}${event.time != null ? " ${event.time}" : ''}",
                              organizer.name,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        const SizedBox(height: 8),
                        if (address != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address.fullAddress,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  DateTile(event: event),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
