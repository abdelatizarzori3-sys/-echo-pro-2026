import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<ChatLoadMessages>(_onLoadMessages);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatClearMessages>(_onClearMessages);
    on<ChatLoadSessions>(_onLoadSessions);
    on<ChatSelectSession>(_onSelectSession);
  }

  Future<void> _onLoadMessages(ChatLoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await _repository.getMessages(event.sessionId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatLoaded(messages: messages, sessionId: event.sessionId)),
    );
  }

  Future<void> _onSendMessage(ChatSendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty) return;
    final current = state;
    if (current is ChatLoaded) {
      final userMsg = Message(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        content: event.text.trim(),
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );
      emit(current.copyWith(messages: [...current.messages, userMsg], isTyping: true));

      final result = await _repository.sendMessage(event.text.trim(), current.sessionId);
      result.fold(
        (failure) {
          final errMsg = Message(
            id: 'err_${DateTime.now().millisecondsSinceEpoch}',
            content: '⚠️ ${failure.message}',
            sender: MessageSender.agent,
            timestamp: DateTime.now(),
            isError: true,
          );
          emit(current.copyWith(messages: [...current.messages, errMsg], isTyping: false));
        },
        (message) => emit(current.copyWith(messages: [...current.messages, message], isTyping: false)),
      );
    }
  }

  Future<void> _onClearMessages(ChatClearMessages event, Emitter<ChatState> emit) async {
    final current = state;
    if (current is ChatLoaded) {
      await _repository.clearChat(current.sessionId);
      emit(current.copyWith(messages: []));
    }
  }

  Future<void> _onLoadSessions(ChatLoadSessions event, Emitter<ChatState> emit) async {
    final result = await _repository.getSessions();
    if (state is ChatLoaded) {
      final current = state as ChatLoaded;
      result.fold(
        (_) => emit(current),
        (sessions) => emit(current.copyWith(sessions: sessions)),
      );
    }
  }

  void _onSelectSession(ChatSelectSession event, Emitter<ChatState> emit) {
    add(ChatLoadMessages(sessionId: event.sessionId));
  }
}
