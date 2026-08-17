import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo/main.dart';

void main() {
  testWidgets('Echo Pro app renders login', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoApp());
    expect(find.text('Echo Pro'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
