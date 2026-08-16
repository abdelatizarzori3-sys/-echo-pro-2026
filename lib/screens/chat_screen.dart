import 'package:flutter/material.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input.dart';
import '../widgets/empty_chat.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatBloc _bloc = ChatBloc();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc.state.listen((state) {
      if (state is ChatLoaded) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(bloc: _bloc),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<ChatState>(
              stream: _bloc.state,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatError) {
                  return Center(child: Text('❌ ${state.error}'));
                }
                if (state is ChatLoaded) {
                  if (state.messages.isEmpty && !state.isTyping) {
                    return const EmptyChat();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isTyping && index == state.messages.length) {
                        return const TypingIndicator();
                      }
                      return MessageBubble(message: state.messages[index]);
                    },
                  );
                }
                return const EmptyChat();
              },
            ),
          ),
          ChatInput(bloc: _bloc),
        ],
      ),
    );
  }
}
