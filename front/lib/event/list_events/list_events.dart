import 'package:flutter/material.dart';
import 'package:front/core/extensions/string.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/partials/event_card.dart';
import 'package:front/core/services/group_services.dart';
import 'package:front/core/services/user_services.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:front/local.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ListEvents extends StatefulWidget {
  final int? groupId;

  const ListEvents({
    super.key,
    this.groupId,
  });

  @override
  State<ListEvents> createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {
  int _currentPage = 1;
  int _totalPages = 1;
  final PagingController<int, Event> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchEvents(pageKey, widget.groupId);
      final isLastPage = _currentPage >= _totalPages;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<Event>> fetchEvents(int page, int? groupId) async {
    final Paginated<Event> resultsPage;
    if (groupId != null) {
      resultsPage = await GroupServices.getGroupNextEvents(
        groupId: groupId,
        page: page,
      );
    } else {
      resultsPage = await UserServices.getUserNextEvents(
        page: page,
      );
    }

    _currentPage = resultsPage.page;
    _totalPages = resultsPage.pages;

    return resultsPage.rows.toList();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Event>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Event>(
        itemBuilder: (context, event, index) {
          EventCard eventCard = EventCard(
            event: event,
            onTap: () {
              EventScreen.navigateTo(context, groupId: event.groupId, eventId: event.id);
            },
          );

          // if preceding event isn't on the same month, show the month's name
          if (index == 0 || event.date.month != _pagingController.itemList![index - 1].date.month) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0, right: 4.0),
                  child: Text(
                    '${DateFormat.MMMM(LocaleLanguage.of(context)?.locale).format(event.date).capitalize()} ${event.date.year}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                eventCard,
              ],
            );
          }

          return eventCard;
        },
        noItemsFoundIndicatorBuilder: (context) =>
            Center(
              child: Text(AppLocalizations.of(context)!.noNextEvent),
            ),
      ),
    );
  }
}
