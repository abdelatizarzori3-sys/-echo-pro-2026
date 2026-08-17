import '../models/message_model.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import 'chat_state.dart';
import 'chat_event.dart';

class ChatBloc {
  final _stateController = StreamController<ChatState>.broadcast();
  final _eventController = StreamController<ChatEvent>();

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isProcessing = false;

  Stream<ChatState> get state => _stateController.stream;
  Sink<ChatEvent> get events => _eventController.sink;

  ChatBloc() {
    _eventController.stream.listen(_handleEvent);
    _stateController.add(ChatLoaded(_messages));
  }

  void _handleEvent(ChatEvent event) async {
    if (event is SendMessageEvent) {
      if (_isProcessing || event.text.trim().isEmpty) return;

      _isProcessing = true;
      final userMsg = ChatMessage(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        content: event.text.trim(),
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );
      _messages.add(userMsg);
      _isTyping = true;
      _emitState();

      try {
        final response = await ApiService.sendMessage(event.text.trim());
        _isTyping = false;
        _messages.add(response);
      } on Exception catch (e) {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: 'err_${DateTime.now().millisecondsSinceEpoch}',
          content: '⚠️ خطأ: $e',
          sender: MessageSender.agent,
          timestamp: DateTime.now(),
          isError: true,
        ));
      } finally {
        _isProcessing = false;
        _emitState();
      }
    } else if (event is ReceiveMessageEvent) {
      _messages.add(event.message);
      _emitState();
    } else if (event is ClearChatEvent) {
      _messages.clear();
      _emitState();
    }
  }

  void _emitState() {
    _stateController.add(ChatLoaded(List.unmodifiable(_messages), isTyping: _isTyping));
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
