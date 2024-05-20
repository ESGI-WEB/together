part of 'group_bloc.dart';

@immutable
abstract class GroupEvent {}

class LoadGroups extends GroupEvent {}

class CreateGroup extends GroupEvent {
  final Map<String, dynamic> newGroup;

  CreateGroup(this.newGroup);
}

class JoinGroup extends GroupEvent {
  final int groupId;

  JoinGroup(this.groupId);
}