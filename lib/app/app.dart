import 'package:flutter/material.dart';
import 'package:flutter_app/providers/app_state.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[600]!),
        ),
        initialRoute: '/',
        routes: {'/': (context) => LoginAndSignUp()},
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
