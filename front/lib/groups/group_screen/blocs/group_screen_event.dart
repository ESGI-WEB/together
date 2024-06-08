part of 'group_screen_bloc.dart';

@immutable
sealed class GroupScreenEvent {}

class LoadGroupScreen extends GroupScreenEvent {
  final int groupId;

  LoadGroupScreen({required this.groupId});
}
