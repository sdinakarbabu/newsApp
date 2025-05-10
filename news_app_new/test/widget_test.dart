import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:news_app_new/main.dart';

void main() {
  testWidgets('NewsApp loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    
    // Wait for potential animations to complete
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('News Aggregator'), findsOneWidget); // Updated to match actual title
    expect(find.byType(GetMaterialApp), findsOneWidget); // Verify GetX is initialized
  });
}
