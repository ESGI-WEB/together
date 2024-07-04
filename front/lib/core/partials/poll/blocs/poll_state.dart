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
}

class PollState {
  final PollStatus status;
  final Paginated<Poll>? pollPage;
  final Poll? pollUpdated;
  final String? errorMessage;
  final JwtData? userData;

  PollState({
    this.status = PollStatus.initial,
    this.pollPage,
    this.pollUpdated,
    this.errorMessage,
    this.userData,
  });

  PollState copyWith({
    PollStatus? status,
    Paginated<Poll>? pollPage,
    Poll? pollUpdated,
    String? errorMessage,
    JwtData? userData,
  }) {
    return PollState(
      status: status ?? this.status,
      pollPage: pollPage ?? this.pollPage,
      pollUpdated: pollUpdated ?? this.pollUpdated,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }
}
