import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessageRequested>(_onSendMessageRequested);
    on<LoadMessagesRequested>(_onLoadMessagesRequested);
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // TODO: Call API to send message
      await Future.delayed(const Duration(seconds: 1));
      emit(ChatLoaded(messages: [
        {'id': '1', 'text': event.message, 'isUser': true}
      ]));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onLoadMessagesRequested(
    LoadMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // TODO: Call API to load messages
      await Future.delayed(const Duration(seconds: 1));
      emit(const ChatLoaded(messages: []));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}
