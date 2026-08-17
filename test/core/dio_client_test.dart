import 'package:flutter_test/flutter_test.dart';
import 'package:echo/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    test('creates singleton instance', () {
      final client1 = DioClient();
      final client2 = DioClient();
      expect(identical(client1, client2), isTrue);
    });

    test('has correct base URL', () {
      final client = DioClient();
      expect(client.dio.options.baseUrl, isNotEmpty);
    });

    test('has timeout configured', () {
      final client = DioClient();
      expect(client.dio.options.connectTimeout, isNotNull);
      expect(client.dio.options.receiveTimeout, isNotNull);
    });
  });
}
