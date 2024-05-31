part of 'group_bloc.dart';

@immutable
abstract class GroupEvent {}

class LoadGroups extends GroupEvent {}

class CreateGroup extends GroupEvent {
  final Map<String, dynamic> newGroup;

  CreateGroup(this.newGroup);
}

class JoinGroup extends GroupEvent {
  final Map<String, dynamic> code;

  JoinGroup(this.code);
}

class LoadGroup extends GroupEvent {
  final int groupId;

  LoadGroup(this.groupId);
}

class LoadGroupNextEvent extends GroupEvent {
  final int groupId;

  LoadGroupNextEvent(this.groupId);
}
