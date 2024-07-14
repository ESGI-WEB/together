part of 'closed_poll_bloc.dart';

enum ClosedPollStatus {
  initial,
  loadingClosedPolls,
  closedPollsSuccess,
  loadClosedPollsError,
}

class ClosedPollState {
  final ClosedPollStatus status;
  final Paginated<Poll>? pollPage;
  final String? errorMessage;
  final JwtData? userData;

  ClosedPollState({
    this.status = ClosedPollStatus.initial,
    this.pollPage,
    this.errorMessage,
    this.userData,
  });

  ClosedPollState copyWith({
    ClosedPollStatus? status,
    Paginated<Poll>? pollPage,
    String? errorMessage,
    JwtData? userData,
  }) {
    return ClosedPollState(
      status: status ?? this.status,
      pollPage: pollPage ?? this.pollPage,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }
}
