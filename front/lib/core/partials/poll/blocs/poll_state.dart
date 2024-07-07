part of 'poll_bloc.dart';

enum PollStatus {
  initial,
  loading,
  success,
  error,
  savingPollChoice,
  pollChoiceSaved,
  pollChoiceSaveError,
  gettingPoll,
  gotPoll,
  getPollError,
  creatingPoll,
  pollCreated,
  createPollError,
  deletingPoll,
  pollDeleted,
  deletePollError,
  closingPoll,
  pollClosed,
  closePollError,
}

class PollState {
  final PollStatus status;
  final Paginated<Poll>? pollPage;
  final Poll? pollUpdated;
  final String? errorMessage;
  final JwtData? userData;
  final int? id;
  final PollType? type;

  PollState({
    this.status = PollStatus.initial,
    this.pollPage,
    this.pollUpdated,
    this.errorMessage,
    this.userData,
    this.id,
    this.type,
  });

  PollState copyWith({
    PollStatus? status,
    Paginated<Poll>? pollPage,
    Poll? pollUpdated,
    String? errorMessage,
    JwtData? userData,
    int? id,
    PollType? type,
  }) {
    return PollState(
      status: status ?? this.status,
      pollPage: pollPage ?? this.pollPage,
      pollUpdated: pollUpdated ?? this.pollUpdated,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }
}
