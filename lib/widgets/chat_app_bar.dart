import 'package:flutter/material.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatBloc bloc;

  const ChatAppBar({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Echo 🤖'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'مسح المحادثة',
          onPressed: () => bloc.events.add(ClearChatEvent()),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
