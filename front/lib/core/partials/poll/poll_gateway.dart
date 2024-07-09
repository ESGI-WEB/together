import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/chat/blocs/websocket_bloc.dart';
import 'package:front/chat/blocs/websocket_state.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll_choice.dart';
import 'package:front/core/partials/poll/all_poll_answered.dart';
import 'package:front/core/partials/poll/create_poll.dart';
import 'package:front/core/partials/poll/no_poll_created.dart';
import 'package:front/core/partials/poll/poll_field.dart';
import 'package:front/core/partials/poll/poll_owner_menu.dart';
import 'package:shimmer/shimmer.dart';
import 'package:front/core/models/poll.dart';

import 'blocs/poll_bloc.dart';
import 'closed_polls/closed_polls.dart';

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
  Paginated<Poll>? currentPage;
  var pollList = <Poll>[];
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

  void pollDeleted(BuildContext context) {
    setState(() {
      // reload current page
      BlocProvider.of<PollBloc>(context).add(
        PollNextPageLoaded(
          id: widget.id,
          page: currentPage != null ? currentPage!.page : 1,
        ),
      );
    });
  }

  void pollUpdated(Poll poll, BuildContext context) {
    if (poll.isClosed) {
      // if the poll is closed, we need to remove it from the list
      pollDeleted(context);
    } else if (pollList.isEmpty || currentPage == null || currentPage!.page == currentPage!.pages){
      // if the poll is not in the list or it the first one to be created
      // or if the user is on the last page of the poll list
      // we need to refresh the page
      BlocProvider.of<PollBloc>(context).add(
          PollNextPageLoaded(
              id: widget.id,
              page: currentPage != null ? currentPage!.page : 1
          )
      );
    } else {
      final index = pollList.indexWhere((element) => element.id == poll.id);
      if (index != -1) {
        setState(() {
          pollList[index] = poll;
        });
      }
    }
  }

  void closeDialog() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void openDialog({
    required BuildContext context,
    required PollState state,
    Poll? poll,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext modalContext) {
        return Dialog(
          surfaceTintColor: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: CreatePoll(
                pollToEdit: poll,
                saving: state.status == PollStatus.creatingPoll,
                onSave: (question, allowMultipleAnswers, answers) {
                  BlocProvider.of<PollBloc>(context).add(
                    PollCreatedOrEdited(
                      poll: PollCreateOrEdit(
                        id: poll?.id,
                        question: question,
                        isMultiple: allowMultipleAnswers,
                        choices: answers,
                        groupId:
                            widget.type == PollType.group ? widget.id : null,
                        eventId:
                            widget.type == PollType.event ? widget.id : null,
                      ),
                    ),
                  );
                },
                onClose: closeDialog,
              ),
            ),
          ),
        );
      },
    );
  }

  void deletePoll(BuildContext context, int id) {
    BlocProvider.of<PollBloc>(context).add(
      PollDeleted(
        id: id,
      ),
    );
  }

  void closePoll(BuildContext context, int id) {
    BlocProvider.of<PollBloc>(context).add(
      PollClosed(
        id: id,
      ),
    );
  }

  void openClosedPolls(BuildContext context, int id, PollType type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: ClosedPolls(
            id: id,
            type: type,
          ),
        );
      },
    );
  }

  PollOwnerMenu _buildMenu(
    BuildContext context,
    PollState state,
    Poll currentPoll,
  ) {
    return PollOwnerMenu(
      onAddPoll: () => openDialog(
        context: context,
        state: state,
      ),
      onEditPoll: () => openDialog(
        context: context,
        state: state,
        poll: currentPoll,
      ),
      onDeletePoll: () => deletePoll(context, currentPoll.id),
      onClosePoll: () => closePoll(context, currentPoll.id),
      onSeeClosedPolls: () => openClosedPolls(
        context,
        widget.id,
        widget.type,
      ),
      isOnDeletePollLoading: state.status == PollStatus.deletingPoll,
      isOnClosePollLoading: state.status == PollStatus.closingPoll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PollBloc()..add(PollNextPageLoaded(id: widget.id)),
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          return BlocListener<WebSocketBloc, WebSocketState>(
            listener: (context, state) {
                if (state is PollUpdatedState) {
                  pollUpdated(state.poll, context);
                }
                if (state is PollDeletedState) {
                  pollDeleted(context);
                }
            },
            child: BlocListener<PollBloc, PollState>(
              listener: (context, state) {
                if (state.status == PollStatus.success) {
                  setState(() {
                    currentPage = state.pollPage;
                    if (currentPage?.page == 1) {
                      pollList = state.pollPage?.rows ?? [];
                    } else {
                      // add the new polls to the list check if the poll isn't already in the list
                      state.pollPage?.rows.forEach((poll) {
                        if (!pollList.any((element) => element.id == poll.id)) {
                          pollList.add(poll);
                        }
                      });
                      goToNextPoll(context);
                    }

                    // prevent currentIndex to be higher than the pollList length
                    // and that it is not negative
                    if (currentPollIndex >= pollList.length) {
                      currentPollIndex = max(0, pollList.length - 1);
                    }
                  });
                }

                if (state.status == PollStatus.pollCreated) {
                  closeDialog();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Le sondage a été enregistré avec succès'),
                    ),
                  );
                }

                if (state.status == PollStatus.createPollError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Une erreur est survenue lors de la sauvegarde du sondage'),
                    ),
                  );
                }
              },
              child: BlocBuilder<PollBloc, PollState>(
                builder: (context, state) {
                  if (state.status == PollStatus.loading && pollList.isEmpty) {
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
                    return NoPollCreated(
                      onTap: () => openDialog(
                        context: context,
                        state: state,
                      ),
                      onSeeClosedPolls: () => openClosedPolls(
                        context,
                        widget.id,
                        widget.type,
                      ),
                    );
                  }

                  final currentPoll = pollList[currentPollIndex];

                  return Stack(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              if (showEveryPollsAnswered)
                                const AllPollAnswered()
                              else
                                PollField(
                                  poll: currentPoll,
                                  selectedChoices: currentPoll.choices
                                      ?.where((choice) =>
                                  choice.users?.any((user) =>
                                  user.id == state.userData?.id) ??
                                      false)
                                      .map((choice) => choice.id)
                                      .toList(),
                                  onChoiceSelected: (choiceId, isSelected) {
                                    BlocProvider.of<PollBloc>(context)
                                        .add(PollChoiceSaved(
                                      pollId: currentPoll.id,
                                      choiceId: choiceId,
                                      selected: isSelected,
                                    ));
                                  },
                                  onChoiceAdded: (choice) {
                                    BlocProvider.of<PollBloc>(context).add(
                                      ChoiceAdded(
                                        poll: currentPoll,
                                        choice: PollChoiceCreateOrEdit(
                                          choice: choice,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: currentPollIndex <= 0 &&
                                        !showEveryPollsAnswered
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
                      ),
                      if (!showEveryPollsAnswered)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _buildMenu(context, state, currentPoll),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
