part of 'groups_bloc.dart';

@immutable
sealed class GroupsEvent {}

class GroupsLoaded extends GroupsEvent {}

class GroupsLoadMore extends GroupsEvent {}

class GroupJoined extends GroupsEvent {
  final Group group;

  GroupJoined(this.group);
}