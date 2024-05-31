part of 'next_event_of_group_bloc.dart';

@immutable
sealed class NextEventOfGroupEvent {}

class NextEventOfGroupLoaded extends NextEventOfGroupEvent {
  final int groupId;

  NextEventOfGroupLoaded({required this.groupId});
}
