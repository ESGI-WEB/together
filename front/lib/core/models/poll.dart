
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

  PollCreateOrEdit toCreateOrEdit() {
    return PollCreateOrEdit(
      id: id,
      question: question,
      isMultiple: isMultiple,
      isClosed: isClosed,
      choices: choices?.map((choice) => choice.toCreateOrEdit()).toList(),
      groupId: groupId,
      eventId: eventId,
    );
  }
}

class PollCreateOrEdit {
  final int? id;
  final String? question;
  final bool? isMultiple;
  final bool? isClosed;
  final List<PollChoiceCreateOrEdit>? choices;
  final int? groupId;
  final int? eventId;

  PollCreateOrEdit({
    this.id,
    this.question,
    this.isMultiple,
    this.isClosed,
    this.choices,
    this.groupId,
    this.eventId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'question': question,
      'is_multiple': isMultiple ?? false,
      'is_closed': isClosed ?? false,
      'choices': choices?.map((choice) => choice.toJson()).toList(),
    };

    if (groupId != null) {
      data['group_id'] = groupId;
    }

    if (eventId != null) {
      data['event_id'] = eventId;
    }

    if (id != null) {
      data['ID'] = id;
    }

    return data;
  }
}