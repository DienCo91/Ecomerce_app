import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login_signup/widgets/login.dart';
import 'package:flutter_app/screens/login_signup/widgets/sign_up.dart';

class LoginAndSignUp extends StatelessWidget {
  const LoginAndSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 20,
          backgroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
            padding: EdgeInsets.only(left: 32, right: 32),
            tabs: [Tab(text: "Login"), Tab(text: "Sign Up")],
          ),
        ),
        body: TabBarView(children: [Login(), SignUp()]),
      ),
    );
  }
}
