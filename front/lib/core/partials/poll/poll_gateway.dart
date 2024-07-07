import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/partials/poll/all_poll_answered.dart';
import 'package:front/core/partials/poll/create_poll.dart';
import 'package:front/core/partials/poll/no_poll_created.dart';
import 'package:front/core/partials/poll/poll.dart';
import 'package:front/core/partials/poll/poll_owner_menu.dart';
import 'package:shimmer/shimmer.dart';
import 'package:front/core/models/poll.dart';

import 'blocs/poll_bloc.dart';
import 'closed_polls.dart';

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

  void choiceChanged(Poll poll, BuildContext context) {
    BlocProvider.of<PollBloc>(context).add(PollUpdated(
      id: poll.id,
    ));
  }

  void updatePoll(Poll poll) {
    final index = pollList.indexWhere((element) => element.id == poll.id);
    if (index != -1) {
      setState(() {
        pollList[index] = poll;
      });
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
      child: BlocListener<PollBloc, PollState>(
        listener: (context, state) {
          if (state.status == PollStatus.success) {
            setState(() {
              currentPage = state.pollPage;
              if (currentPage?.page == 1) {
                currentPollIndex = 0;
                pollList = state.pollPage?.rows ?? [];
              } else {
                currentPollIndex = currentPollIndex + 1;
                pollList.addAll(state.pollPage?.rows ?? []);
              }
            });
          }

          if (state.status == PollStatus.pollChoiceSaved &&
              state.pollUpdated != null) {
            updatePoll(state.pollUpdated!);
          }

          if (state.status == PollStatus.pollCreated) {
            closeDialog();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Le sondage a été ajouté avec succès'),
              ),
            );
          }

          if (state.status == PollStatus.createPollError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Une erreur est survenue lors de la création du sondage'),
              ),
            );
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

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
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
                                }),
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
                ),
                if (!showEveryPollsAnswered)
                  _buildMenu(context, state, currentPoll),
              ],
            );
          },
        ),
      ),
    );
  }
}
