import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  ChatRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<Message>>> getMessages(String? sessionId) async {
    try {
      final response = await _dio.get(ApiConstants.messages, queryParameters: {
        if (sessionId != null) 'sessionId': sessionId,
      });
      final List data = response.data['data'];
      return Right(data.map((e) => MessageModel.fromJson(e)).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Failed to load messages'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(String text, String? sessionId) async {
    try {
      final response = await _dio.post(ApiConstants.send, data: {
        'text': text,
        if (sessionId != null) 'sessionId': sessionId,
      });
      return Right(MessageModel.fromJson(response.data['data']['message']));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, void>> clearChat(String? sessionId) async {
    try {
      await _dio.delete(ApiConstants.messages, queryParameters: {
        if (sessionId != null) 'sessionId': sessionId,
      });
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Failed to clear chat'));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getSessions() async {
    try {
      final response = await _dio.get(ApiConstants.sessions);
      final List data = response.data['data'];
      return Right(data.map((e) => Session(
        id: e['id'],
        title: e['title'],
        updatedAt: DateTime.tryParse(e['updated_at'] ?? '') ?? DateTime.now(),
        messageCount: e['_count']?['messages'] ?? 0,
      )).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['error'] ?? 'Failed to load sessions'));
    }
  }
}
