import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(String? sessionId);
  Future<Either<Failure, Message>> sendMessage(String text, String? sessionId);
  Future<Either<Failure, void>> clearChat(String? sessionId);
  Future<Either<Failure, List<Session>>> getSessions();
}

class Session {
  final String id;
  final String? title;
  final DateTime updatedAt;
  final int messageCount;

  Session({required this.id, this.title, required this.updatedAt, required this.messageCount});
}
