part of 'closed_poll_bloc.dart';

@immutable
sealed class ClosedPollEvent {}

class ClosedPollNextPageLoaded extends ClosedPollEvent {
  final int id;
  final PollType type;
  final int page;

  ClosedPollNextPageLoaded({
    required this.id,
    this.type = PollType.group,
    required this.page,
  });
}
