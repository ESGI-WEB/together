import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:web_socket_channel/io.dart';

class ChatService {
  static final String _baseUrl =
      dotenv.env['WEB_SOCKET_URL'] ?? 'ws://10.0.2.2:8080/ws';

  static Future<IOWebSocketChannel> getChannel() async {
    final token = await StorageService.readToken();

    final channel = IOWebSocketChannel.connect(
      _baseUrl,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return channel;
  }
}
