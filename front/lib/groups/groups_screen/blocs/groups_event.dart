part of 'groups_bloc.dart';

@immutable
sealed class GroupsEvent {}

class GroupsLoaded extends GroupsEvent {
  final int page;

  GroupsLoaded({this.page = 1});
}

class GroupsLoadMore extends GroupsEvent {}

class GroupJoined extends GroupsEvent {
  final Group group;

  GroupJoined(this.group);
}