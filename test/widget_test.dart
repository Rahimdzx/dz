import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caldz/main.dart'; // Adjust the package name if necessary

void main() {
  testWidgets('MyApp has a title and a button', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Real-Time Average Calculator'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2)); // Check for two buttons
  });
}
