import 'package:flutter/material.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class ChatInput extends StatefulWidget {
  final ChatBloc bloc;

  const ChatInput({super.key, required this.bloc});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void _send() {
    final text = _controller.text;
    if (text.trim().isNotEmpty) {
      widget.bloc.events.add(SendMessageEvent(text));
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: null,
                maxLength: 4000,
                textInputAction: TextInputAction.send,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintTextDirection: TextDirection.rtl,
                  counterText: '',
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'sendButton',
              onPressed: _send,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
