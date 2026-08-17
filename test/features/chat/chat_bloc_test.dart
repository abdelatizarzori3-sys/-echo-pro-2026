import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:echo/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:echo/features/chat/presentation/bloc/chat_event.dart';
import 'package:echo/features/chat/presentation/bloc/chat_state.dart';
import 'package:echo/features/chat/domain/repositories/chat_repository.dart';
import 'package:echo/features/chat/domain/entities/message.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late ChatBloc chatBloc;

  setUp(() {
    mockRepo = MockChatRepository();
    chatBloc = ChatBloc(chatRepository: mockRepo);
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc', () {
    final testMessage = Message(
      id: '1',
      content: 'Hello AI',
      sender: 'user',
      sessionId: 'session-1',
      createdAt: DateTime.now(),
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoading, ChatMessagesLoaded] when messages requested',
      build: () {
        when(() => mockRepo.getMessages('session-1'))
            .thenAnswer((_) async => [testMessage]);
        return chatBloc;
      },
      act: (bloc) => bloc.add(const ChatMessagesRequested('session-1')),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatMessagesLoaded>(),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoading, ChatError] when message send fails',
      build: () {
        when(() => mockRepo.sendMessage(any(), any()))
            .thenThrow(Exception('Network error'));
        return chatBloc;
      },
      act: (bloc) => bloc.add(
        const ChatMessageSent('Hello', 'session-1'),
      ),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatError>(),
      ],
    );
  });
}
