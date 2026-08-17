import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF6B4EFF)),
            child: const Center(
              child: Text('Echo Pro', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Chat'),
            onTap: () {
              context.read<ChatBloc>().add(const ChatLoadMessages());
              Navigator.pop(context);
            },
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoaded && state.sessions != null) {
                  return ListView.builder(
                    itemCount: state.sessions!.length,
                    itemBuilder: (_, index) {
                      final session = state.sessions![index];
                      return ListTile(
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: Text(session.title ?? 'New Chat'),
                        subtitle: Text('${session.messageCount} messages'),
                        onTap: () {
                          context.read<ChatBloc>().add(ChatSelectSession(session.id));
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
