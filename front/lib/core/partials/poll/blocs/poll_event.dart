part of 'poll_bloc.dart';

@immutable
sealed class PollEvent {}

class PollNextPageLoaded extends PollEvent {
  final int id;
  final PollType type;
  final int page;

  PollNextPageLoaded({
    required this.id,
    this.type = PollType.group,
    this.page = 1,
  });
}

class PollUpdated extends PollEvent {
  final int id;

  PollUpdated({
    required this.id,
  });
}

class PollChoiceSaved extends PollEvent {
  final int pollId;
  final int choiceId;
  final bool selected;

  PollChoiceSaved({
    required this.pollId,
    required this.choiceId,
    this.selected = true,
  });
}

class PollCreated extends PollEvent {
  final PollCreateOrEdit poll;

  PollCreated({
    required this.poll,
  });
}

enum PollType {
  group,
  event,
}
