import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo/main.dart';

void main() {
  testWidgets('Echo app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoApp());
    expect(find.text('Echo 🤖'), findsOneWidget);
  });
}
