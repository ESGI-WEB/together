import 'package:front/core/models/user.dart';

class PollChoice {
  final int id;
  final String choice;
  final int pollId;
  final List<User>? users;

  PollChoice({
    required this.id,
    required this.choice,
    required this.pollId,
    this.users,
  });

  factory PollChoice.fromJson(Map<String, dynamic> json) {
    return PollChoice(
      id: json['ID'],
      choice: json['choice'],
      pollId: json['poll_id'],
      users: (json['users'] as List).map((user) => User.fromJson(user)).toList(),
    );
  }
}