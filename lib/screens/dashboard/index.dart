import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/account_details/index.dart';
import 'package:flutter_app/screens/account_security/index.dart';
import 'package:flutter_app/screens/order/index.dart';
import 'package:flutter_app/screens/products_manage/index.dart';
import 'package:flutter_app/screens/review/index.dart';
import 'package:flutter_app/screens/users/index.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    bool isAdmin = authController.user.value?.user.role == "ROLE ADMIN";

    final List<Map<String, dynamic>> listDashBoard = [
      {"title": "Account Details", "icon": Icons.person, "to": AccountDetails()},
      {"title": "Account Security", "icon": Icons.security, "to": AccountSecurity()},
      {"title": "Orders", "icon": Icons.shopping_cart, "to": Order()},
    ];

    if (isAdmin) {
      listDashBoard.addAll([
        {"title": "Review", "icon": Icons.comment, "to": ReviewScreen()},
        {"title": "Products", "icon": Icons.list, "to": ProductsManage()},
        {"title": "Users", "icon": Icons.people, "to": UserList()},
      ]);
    }

    void handleLogout() async {
      setState(() {
        isLoading = true;
      });
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await authController.clearUser();
      setState(() {
        isLoading = false;
      });
    }

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
            onPressed: handleLogout,
            icon:
                isLoading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                    : const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading ? Colors.grey : Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
