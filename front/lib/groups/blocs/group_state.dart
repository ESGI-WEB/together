part of 'group_bloc.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupLoadSuccess extends GroupState {
  final List<Group> groups;

  GroupLoadSuccess({required this.groups});
}

final class GroupLoadError extends GroupState {
  final String errorMessage;

  GroupLoadError({required this.errorMessage});
}

final class GroupLoadSingleSuccess extends GroupState {
  final Group group;

  GroupLoadSingleSuccess({required this.group});
}
