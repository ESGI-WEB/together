part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}

class LoadGroup extends GroupEvent {
  final int groupId;

  LoadGroup({required this.groupId});
}
