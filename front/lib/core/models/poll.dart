
import 'package:front/core/models/poll_choice.dart';

class Poll {
  final int id;
  final String question;
  final bool isClosed;
  final bool isMultiple;
  final int groupId;
  final int userId;
  final int? eventId;
  final List<PollChoice>? choices;

  Poll({
    required this.id,
    required this.question,
    required this.isClosed,
    required this.isMultiple,
    required this.groupId,
    required this.userId,
    this.eventId,
    required this.choices,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['ID'],
      question: json['question'],
      isClosed: json['is_closed'],
      isMultiple: json['is_multiple'],
      groupId: json['group_id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      choices: (json['choices'] as List).map((choice) => PollChoice.fromJson(choice)).toList(),
    );
  }
}