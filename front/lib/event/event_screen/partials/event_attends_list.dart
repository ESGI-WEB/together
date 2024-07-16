import 'package:flutter/material.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/services/events_services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:front/core/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventAttendsList extends StatefulWidget {
  final int eventId;

  const EventAttendsList({
    super.key,
    required this.eventId,
  });

  @override
  State<EventAttendsList> createState() => _EventAttendsListState();
}

class _EventAttendsListState extends State<EventAttendsList> {
  int _currentPage = 1;
  int _totalPages = 1;
  final PagingController<int, User> _pagingController =
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
      final newItems = await fetchAttendees(widget.eventId, pageKey);
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

  Future<List<User>> fetchAttendees(int eventId, int page) async {
    final resultsPage = await EventsServices.getEventAttends(
      eventId: widget.eventId,
      hasAttended: true,
      page: page,
    );

    _currentPage = resultsPage.page;
    _totalPages = resultsPage.pages;

    return resultsPage.rows
        .where((e) => e.user != null)
        .map((e) => e.user!)
        .toList();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, User>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        itemBuilder: (context, user, index) => ListTile(
          leading: Avatar(
            user: user,
          ),
          title: Text(user.name),
        ),
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: Text(AppLocalizations.of(context)!.noParticipants),
        ),
      ),
    );
  }
}
