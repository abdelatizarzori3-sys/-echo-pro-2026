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

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatLoaded(this.messages, {this.isTyping = false});
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
