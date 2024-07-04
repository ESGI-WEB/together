import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/partials/poll/all_poll_answered.dart';
import 'package:front/core/partials/poll/no_poll_created.dart';
import 'package:front/core/partials/poll/poll.dart';
import 'package:front/core/partials/poll/poll_less.dart';
import 'package:shimmer/shimmer.dart';
import 'package:front/core/models/poll.dart' as poll_model;

import 'blocs/poll_bloc.dart';

class PollGateway extends StatefulWidget {
  final int id;
  final PollType type;

  const PollGateway({
    super.key,
    required this.id,
    this.type = PollType.group,
  });

  @override
  State<PollGateway> createState() => _PollGatewayState();
}

class _PollGatewayState extends State<PollGateway> {
  Paginated<poll_model.Poll>? currentPage;
  var pollList = <poll_model.Poll>[];
  var currentPollIndex = 0;
  var showEveryPollsAnswered = false;

  void goToPreviousPoll() {
    if (showEveryPollsAnswered) {
      setState(() {
        showEveryPollsAnswered = false;
      });
    } else if (currentPollIndex > 0) {
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
    } else {
      setState(() {
        showEveryPollsAnswered = true;
      });
    }
  }

  // faire un bloc listener pour re recuperer un pollid updated
  void choiceChanged(poll_model.Poll poll, BuildContext context) {
    BlocProvider.of<PollBloc>(context).add(PollUpdated(
      id: poll.id,
    ));
  }

  void updatePoll(poll_model.Poll poll) {
    final index = pollList.indexWhere((element) => element.id == poll.id);
    if (index != -1) {
      setState(() {
        pollList[index] = poll;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PollBloc()..add(PollNextPageLoaded(id: widget.id)),
      child: BlocListener<PollBloc, PollState>(
        listener: (context, state) {
          if (state.status == PollStatus.success) {
            setState(() {
              currentPage = state.pollPage;
              pollList.addAll(state.pollPage?.rows ?? []);
              currentPollIndex = currentPollIndex == 0 ? 0 : currentPollIndex + 1;
            });
          }

          if (state.status == PollStatus.pollChoiceSaved && state.pollUpdated != null) {
            updatePoll(state.pollUpdated!);
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
            if (pollPage == null) {
              return const NoPollCreated();
            }

            final currentPoll = pollList[currentPollIndex];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (showEveryPollsAnswered)
                      const AllPollAnswered()
                    else
                      PollLess(
                        poll: currentPoll,
                        selectedChoices: currentPoll.choices
                            ?.where((choice) => choice.users
                                ?.any((user) => user.id == state.userData?.id)
                                ?? false)
                            .map((choice) => choice.id)
                            .toList(),
                        onChoiceSelected: (choiceId, isSelected) {
                          BlocProvider.of<PollBloc>(context).add(PollChoiceSaved(
                            pollId: currentPoll.id,
                            choiceId: choiceId,
                            selected: isSelected,
                          ));

                          // recuperer le poll quand c'est fait puis le mettre a jour
                          // mettre a jour la liste des choix séléctionnés
                        }
                      ),
                      // Poll(
                      //     poll: currentPoll,
                      //     defaultSelectedChoices: currentPoll.choices
                      //         ?.where((choice) => choice.users
                      //             ?.any((user) => user.id == state.userData?.id)
                      //             ?? false)
                      //         .map((choice) => choice.id)
                      //         .toList(),
                      //     onChoiceChanged: (selectedChoices) {
                      //       choiceChanged(currentPoll, context);
                      //     }
                      // ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: currentPollIndex <= 0
                              ? null
                              : goToPreviousPoll,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Text(
                          '${currentPollIndex + 1} / ${pollPage.total}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        IconButton(
                          onPressed: showEveryPollsAnswered
                              ? null
                              : () => goToNextPoll(context),
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
