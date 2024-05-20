part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}

final class LoadGroups extends GroupEvent {}

final class CreateGroup extends GroupEvent {}

final class JoinGroup extends GroupEvent {}