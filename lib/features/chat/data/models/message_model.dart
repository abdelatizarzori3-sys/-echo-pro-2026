import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    super.isError,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.agent,
      timestamp: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isError: json['metadata']?['isError'] ?? false,
    );
  }
}
