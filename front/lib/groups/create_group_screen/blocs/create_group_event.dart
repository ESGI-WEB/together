part of 'create_group_bloc.dart';

@immutable
sealed class CreateGroupEvent {}

class CreateGroupSubmitted extends CreateGroupEvent {
  final Map<String, dynamic> newGroup;

  CreateGroupSubmitted(this.newGroup);
}
