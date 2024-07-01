import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givison/screens/login/login.screen.dart';
import 'package:givison/screens/signup/signup.screen.dart';
import 'package:givison/screens/welcome/welcome.screen.dart';

void main() {
  testWidgets('WelcomeScreen UI Test', (WidgetTester tester) async {
    // Build the WelcomeScreen widget
    await tester.pumpWidget(const MaterialApp(
      home: WelcomeScreen(),
    ));

    // Verify that the title and subtitle are displayed correctly
    expect(find.text('Welcome to Givison'), findsOneWidget);
    expect(find.text('Sign Up to get started'), findsOneWidget);

    // Verify that the Sign Up button is displayed and clickable
    expect(find.text('Sign Up'), findsOneWidget);
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle(); // Wait for the transition animation to complete
    expect(find.byType(SignUpScreen), findsOneWidget);

    // Verify that the "Already have an account?" text and "Login" link are displayed and can be clicked
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for the transition animation to complete
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

//Need to find more innovative ways to test 
