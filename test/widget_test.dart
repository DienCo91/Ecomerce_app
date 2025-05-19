import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:flutter_app/screens/login_signup/widgets/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    debugSemanticsDisableAnimations = true;
  });

  testWidgets('LoginAndSignUp shows tabs and login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginAndSignUp()));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Sign Up'), findsWidgets);
    expect(find.byType(Login), findsOneWidget);
  });
}
