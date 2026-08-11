import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mastery/core/storage/storage_helper.dart';
import 'package:flutter_mastery/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Setup mock values for SharedPreferences
    SharedPreferences.setMockInitialValues({});
    await StorageHelper.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the onboarding flow is rendered
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
