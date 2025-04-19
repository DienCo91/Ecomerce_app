import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/instance_manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController user = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ID: ${user.user.value?.user.id}"),
          Text("Email: ${user.user.value?.user.email}"),
          Text("First Name: ${user.user.value?.user.firstName}"),
          Text("Role: ${user.user.value?.user.role}"),
        ],
      ),
    );
  }
}
