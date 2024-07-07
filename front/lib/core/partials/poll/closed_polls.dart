import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/partials/poll/poll.dart';
import 'package:shimmer/shimmer.dart';

import 'blocs/poll_bloc.dart';

class ClosedPolls extends StatefulWidget {
  final int id;
  final PollType type;

  const ClosedPolls({
    super.key,
    required this.id,
    this.type = PollType.group,
  });

  @override
  State<ClosedPolls> createState() => _ClosedPollsState();
}

class _ClosedPollsState extends State<ClosedPolls> {
  Paginated<Poll>? currentPage;
  var pollList = <Poll>[];
  var currentPollIndex = 0;

  void goToPreviousPoll() {
    if (currentPollIndex > 0) {
      setState(() {
        currentPollIndex--;
      });
    }
  }

  void goToNextPoll(context) {
    // first check if there is a next poll in pollList
    if (currentPollIndex + 1 < pollList.length) {
      setState(() {
        currentPollIndex++;
      });
      return;
    } else if (currentPage == null || currentPage!.page < currentPage!.pages) {
      // if there is no next poll in pollList but another page to load, load the next page
      BlocProvider.of<PollBloc>(context).add(PollNextPageLoaded(
        id: widget.id,
        page: currentPage != null ? currentPage!.page + 1 : 1,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PollBloc()
        ..add(
          ClosedPollNextPageLoaded(
            id: widget.id,
            type: widget.type,
            page: 1,
          ),
        ),
      child: BlocListener<PollBloc, PollState>(
        listener: (context, state) {
          final page = state.pollPage;
          if (state.status == PollStatus.closedPollsSuccess && page != null) {
            setState(() {
              currentPage = page;
              if (page.page == 1) {
                pollList = page.rows;
              } else {
                pollList.addAll(page.rows);
              }
            });
          }
        },
        child: BlocBuilder<PollBloc, PollState>(
          builder: (context, state) {
            if (state.status == PollStatus.loading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.white,
                ),
              );
            }

            if (state.status == PollStatus.error) {
              return Center(
                  child: Text(state.errorMessage ?? 'Une erreur est survenue'));
            }

            final pollPage = state.pollPage;
            if (pollPage == null || pollPage.rows.isEmpty) {
              return const Center(
                child: Text('Aucun sondage clos'),
              );
            }

            final poll = pollList[currentPollIndex];
            return Column(
              children: [
                PollField(
                  poll: poll,
                  selectedChoices: poll.choices
                      ?.where((choice) =>
                          choice.users
                              ?.map((user) => user.id)
                              .contains(state.userData?.id) ??
                          false)
                      .map((choice) => choice.id)
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: currentPollIndex > 0 ? goToPreviousPoll : null,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: (
                          currentPollIndex + 1 < pollList.length ||
                          (currentPage != null && currentPage!.page < currentPage!.pages)
                      ) ? () => goToNextPoll(context) : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
