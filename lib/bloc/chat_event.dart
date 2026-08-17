import '../models/chat_message.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String text;
  SendMessageEvent(this.text);
}

class ReceiveMessageEvent extends ChatEvent {
  final ChatMessage message;
  ReceiveMessageEvent(this.message);
}

class ClearChatEvent extends ChatEvent {}
