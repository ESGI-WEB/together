part of 'group_screen_bloc.dart';

enum GroupScreenStatus {
  initial,
  loading,
  success,
  error,
}

class GroupScreenState {
  final GroupScreenStatus status;
  final Group? group;
  final String? errorMessage;
  final JwtData? userData;

  GroupScreenState({
    this.status = GroupScreenStatus.initial,
    this.group,
    this.errorMessage,
    this.userData,
  });

  GroupScreenState copyWith({
    GroupScreenStatus? status,
    Group? group,
    String? errorMessage,
    JwtData? userData,
  }) {
    return GroupScreenState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }
}
