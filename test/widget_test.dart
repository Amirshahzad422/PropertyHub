import 'package:flutter_test/flutter_test.dart';

import 'package:propertyhub/app.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PropertyHubApp());

    // Verify that our app shows the Firebase connection text.
    expect(find.text('PropertyHub connected to Firebase!'), findsOneWidget);
  });
}
