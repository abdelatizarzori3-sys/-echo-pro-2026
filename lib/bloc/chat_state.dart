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
