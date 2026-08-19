/**
 * WebSocket Service for Real-time Chat
 */

import 'package:socket_io_client/socket_io_client.js' as IO;

class WebSocketService {
  late IO.Socket socket;
  final String baseUrl;

  WebSocketService({required this.baseUrl});

  void connect(String token) {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ WebSocket connected');
    });

    socket.onDisconnect((_) {
      print('❌ WebSocket disconnected');
    });

    socket.on('receive-message', (data) {
      print('💬 Message received: $data');
    });
  }

  void sendMessage(String roomId, String message) {
    socket.emit('send-message', {'roomId': roomId, 'message': message});
  }

  void joinRoom(String roomId) {
    socket.emit('join-room', roomId);
  }

  void disconnect() {
    socket.disconnect();
  }
}
