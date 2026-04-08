import 'package:flutter_test/flutter_test.dart';

import 'package:count_app/main.dart';

void main() {
  testWidgets('App launches and shows Player Count screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HiddenRulesApp());

    // Verify the Player Count screen is displayed
    expect(find.text('Number Game'), findsOneWidget);
    expect(find.text("LET'S GO!"), findsOneWidget);
  });
}
