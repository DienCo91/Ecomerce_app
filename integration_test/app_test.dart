import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:flutter_app/screens/login_signup/widgets/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('automation test', () {
    testWidgets('Login Success', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: LoginAndSignUp()));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Sign Up'), findsWidgets);
      expect(find.byType(Login), findsOneWidget);

      final emailField = find.byKey(const ValueKey('email_field'));
      final passwordField = find.byKey(const ValueKey('password_field'));

      await tester.enterText(emailField, 'minhtest@yopmail.com');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      await tester.enterText(passwordField, '123123123');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byKey(const ValueKey('login_button')));

      await tester.pumpAndSettle();

      expect(find.text('Shop'), findsWidgets);
    });

    testWidgets('Login Validate', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: LoginAndSignUp()));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byKey(const ValueKey('login_button')));

      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Email required !'), findsWidgets);
      expect(find.text('Password required !'), findsWidgets);
    });

    testWidgets('Sign Up Validate', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: LoginAndSignUp()));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Sign Up'), findsWidgets);

      final signUpTab = find.widgetWithText(Tab, 'Sign Up');
      await tester.tap(signUpTab);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const ValueKey('login_link')), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign up'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Email required !'), findsWidgets);
      expect(find.text('Password required !'), findsWidgets);
      expect(find.text('First Name required !'), findsWidgets);
      expect(find.text('Last Name required !'), findsWidgets);
    });
  });
}
