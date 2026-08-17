part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isTyping;
  final String? sessionId;
  final List<Session>? sessions;

  const ChatLoaded({
    required this.messages,
    this.isTyping = false,
    this.sessionId,
    this.sessions,
  });

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? sessionId,
    List<Session>? sessions,
  }) => ChatLoaded(
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
    sessionId: sessionId ?? this.sessionId,
    sessions: sessions ?? this.sessions,
  );

  @override
  List<Object?> get props => [messages, isTyping, sessionId, sessions];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
