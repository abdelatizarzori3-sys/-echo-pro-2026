import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

// 🔑 NO API KEY HERE - keys stay in Railway Variables only!
// Frontend connects to Backend → Backend connects to Kimi

class ApiService {
  static const String _baseUrl = 'https://echo-api.up.railway.app';

  static Future<ChatMessage> sendMessage(String text) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChatMessage(
        id: 'agent_${DateTime.now().millisecondsSinceEpoch}',
        content: data['reply'],
        sender: MessageSender.agent,
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('فشل: ${response.statusCode}');
    }
  }

  static Future<List<ChatMessage>> fetchMessages() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/messages'));
    final List data = jsonDecode(response.body);
    return data.map((m) => ChatMessage(
      id: m['id'].toString(),
      content: m['content'],
      sender: m['sender'] == 'user' ? MessageSender.user : MessageSender.agent,
      timestamp: DateTime.parse(m['created_at']),
    )).toList();
  }

  static Future<void> clearMessages() async {
    await http.delete(Uri.parse('$_baseUrl/api/messages'));
  }
}
