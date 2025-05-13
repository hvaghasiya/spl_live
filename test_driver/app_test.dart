import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spllive/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete sign in flow test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Wait for splash screen to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify welcome screen elements
    expect(find.byKey(const Key('welcomeScreenLogo')), findsOneWidget);
    expect(find.byKey(const Key('welcomeText')), findsOneWidget);

    // Find and tap the sign in button on welcome screen
    final welcomeScreenSignInButton = find.byKey(const Key('welcomeSignInButton'));
    expect(welcomeScreenSignInButton, findsOneWidget);
    await tester.tap(welcomeScreenSignInButton);
    await tester.pumpAndSettle();

    // Verify sign in screen elements
    expect(find.text('WELCOMEBACK'.tr), findsOneWidget);

    // Enter credentials
    final mobileNumberField = find.byKey(const Key('mobileNumberField'));
    await tester.enterText(mobileNumberField, '1234567890');
    await tester.pumpAndSettle();

    final passwordField = find.byKey(const Key('passwordField'));
    await tester.enterText(passwordField, 'password123');
    await tester.pumpAndSettle();

    // Tap sign in button
    final signInButton = find.byKey(const Key('signInButton'));
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
  });
}
