part of 'groups_screen_bloc.dart';

@immutable
sealed class GroupsScreenEvent {}

class GroupsScreenLoaded extends GroupsScreenEvent {}

class GroupJoined extends GroupsScreenEvent {
  final Group group;

  GroupJoined(this.group);
}