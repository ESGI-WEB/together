part of 'group_bloc.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupsLoadSuccess extends GroupState {
  final List<Group> groups;

  GroupsLoadSuccess({required this.groups});
}

final class GroupsLoadError extends GroupState {
  final String errorMessage;

  GroupsLoadError({required this.errorMessage});
}

final class GroupLoadSingleSuccess extends GroupState {
  final Group group;

  GroupLoadSingleSuccess({required this.group});
}