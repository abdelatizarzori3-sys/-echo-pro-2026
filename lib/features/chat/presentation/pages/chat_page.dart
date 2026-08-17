import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_drawer.dart';
import '../widgets/empty_chat.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>()..add(const ChatLoadMessages()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      drawer: const ChatDrawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (_, state) {
                if (state is ChatLoaded) Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
              },
              builder: (_, state) {
                if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
                if (state is ChatError) return Center(child: Text('❌ ${state.message}'));
                if (state is ChatLoaded) {
                  if (state.messages.isEmpty && !state.isTyping) return const EmptyChat();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (state.isTyping && index == state.messages.length) return const TypingIndicator();
                      return MessageBubble(message: state.messages[index]);
                    },
                  );
                }
                return const EmptyChat();
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
}
