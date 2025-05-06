import 'package:flutter/material.dart';
import 'package:flutter_app/screens/account_details.dart/index.dart';
import 'package:flutter_app/screens/account_security/index.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:flutter_app/screens/order/index.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Map<String, dynamic>> listDashBoard = [
      {"title": "Account Details", "icon": Icons.person, "to": AccountDetails()},
      {"title": "Account Security", "icon": Icons.security, "to": AccountSecurity()},
      {"title": "Orders", "icon": Icons.shopping_cart, "to": Order()},
    ];

    return Column(
      children: [
        Header(icon: Icons.dashboard, iconColor: Colors.blue, title: "Dashboard"),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  listDashBoard.map((item) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            item["to"],
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(item["icon"], color: Colors.blueAccent),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item["title"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.offAll(LoginAndSignUp());
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
