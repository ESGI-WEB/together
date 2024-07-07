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

class ClosedPollNextPageLoaded extends PollNextPageLoaded {
  ClosedPollNextPageLoaded({
    required super.id,
    super.type,
    super.page,
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

class PollCreatedOrEdited extends PollEvent {
  final PollCreateOrEdit poll;

  PollCreatedOrEdited({
    required this.poll,
  });
}

class PollDeleted extends PollEvent {
  final int id;

  PollDeleted({
    required this.id,
  });
}

class PollClosed extends PollEvent {
  final int id;

  PollClosed({
    required this.id,
  });
}

class ChoiceAdded extends PollEvent {
  final Poll poll;
  final PollChoiceCreateOrEdit choice;

  ChoiceAdded({
    required this.poll,
    required this.choice,
  });
}

enum PollType {
  group,
  event,
}
