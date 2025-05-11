import 'package:flutter/material.dart';
import 'package:flutter_app/app/splash.dart';
import 'package:flutter_app/providers/app_state.dart';
import 'package:flutter_app/screens/home/index.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: GetMaterialApp(
        title: 'Flutter App',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[600]!)),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/': (context) => LoginAndSignUp(),
          '/home': (context) => Home(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
