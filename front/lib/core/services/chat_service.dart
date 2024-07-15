import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/api_services.dart';

class ChatService {
  static Future<Reaction?> createReaction(Reaction reaction) async {
    try {
      final response = await ApiServices.post(
          '/messages/${reaction.messageId}/reaction', reaction.toJson());
      return Reaction.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (err) {
      print(err.statusCode);
    } catch (err) {
      print(err);
    }

    return null;
  }
}
