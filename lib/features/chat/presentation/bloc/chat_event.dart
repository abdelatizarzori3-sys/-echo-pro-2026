part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageRequested extends ChatEvent {
  final String message;

  const SendMessageRequested({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadMessagesRequested extends ChatEvent {
  const LoadMessagesRequested();
}
