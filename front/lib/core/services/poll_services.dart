import 'dart:developer';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';

import 'api_services.dart';

class PollServices {
  static Future<Paginated<Poll>> get({
    required int id,
    PollType type = PollType.group,
    int page = 1,
    bool closed = false,
  }) async {
    var urlTypePart = type == PollType.group ? '/group/$id' : '/event/$id';
    var url = '/polls$urlTypePart?page=$page&closed=$closed';

    final response = await ApiServices.get(url);
    return Paginated.fromJson(
      ApiServices.decodeResponse(response),
      (json) => Poll.fromJson(json),
    );
  }

  static Future<Poll> getPollById({
    required int id,
  }) async {
    final response = await ApiServices.get('/polls/$id');
    return Poll.fromJson(ApiServices.decodeResponse(response));
  }

  static Future<void> saveChoice({
    required int pollId,
    required int choiceId,
  }) async {
    try {
      await ApiServices.post(
        '/polls/$pollId/choice/$choiceId/select',
      );
    } on ApiException catch (error) {
      log('Error: ${error.response?.statusCode}');
    }
  }

  static Future<void> deleteChoice({
    required int pollId,
    required int choiceId,
  }) async {
    await ApiServices.post(
      '/polls/$pollId/choice/$choiceId/deselect',
    );
  }

  static Future<Poll> createPoll({
    required PollCreateOrEdit poll,
  }) async {
    final newPoll = await ApiServices.post(
      '/polls',
      poll.toJson(),
    );
    return Poll.fromJson(ApiServices.decodeResponse(newPoll));
  }

  static Future<void> deletePoll({
    required int id,
  }) async {
    await ApiServices.delete('/polls/$id');
  }

  static Future<void> updatePoll({
    required int id,
    Map<String, dynamic>? data,
  }) async {
    await ApiServices.put(
      '/polls/$id',
      data,
    );
  }
}
