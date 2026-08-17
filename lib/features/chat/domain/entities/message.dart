import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isError;

  const Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isError = false,
  });

  @override
  List<Object?> get props => [id, content, sender, timestamp, isError];
}

enum MessageSender { user, agent }
