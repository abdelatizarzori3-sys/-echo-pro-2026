part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatLoadMessages extends ChatEvent {
  final String? sessionId;
  const ChatLoadMessages({this.sessionId});
}

class ChatSendMessage extends ChatEvent {
  final String text;
  const ChatSendMessage(this.text);
}

class ChatClearMessages extends ChatEvent {
  const ChatClearMessages();
}

class ChatLoadSessions extends ChatEvent {
  const ChatLoadSessions();
}

class ChatSelectSession extends ChatEvent {
  final String sessionId;
  const ChatSelectSession(this.sessionId);
}
