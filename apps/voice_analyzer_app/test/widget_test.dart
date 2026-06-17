// Basic smoke test for the Voice Intelligence AI dashboard.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voice_analyzer_app/main.dart';

void main() {
  testWidgets('Dashboard renders its two tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardScreen()),
    );

    expect(find.text('Transcripts'), findsOneWidget);
    expect(find.text('AI Agent'), findsOneWidget);
  });
}
