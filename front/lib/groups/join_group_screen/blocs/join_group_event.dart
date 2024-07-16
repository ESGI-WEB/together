part of 'join_group_bloc.dart';

@immutable
sealed class JoinGroupEvent {}

class JoinGroupSubmitted extends JoinGroupEvent {
  final Map<String, dynamic> code;

  JoinGroupSubmitted(this.code);
}
