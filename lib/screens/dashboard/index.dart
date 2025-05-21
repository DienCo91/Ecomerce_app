import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/account_details.dart/index.dart';
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
  final AuthController _authController = Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  late final bool _isAdmin = _authController.user.value?.user.role == "ROLE ADMIN";

  List<Map<String, dynamic>> get _dashboardItems {
    final items = [
      {"title": "Account Details", "icon": Icons.person, "screen": AccountDetails()},
      {"title": "Account Security", "icon": Icons.security, "screen": AccountSecurity()},
      {"title": "Orders", "icon": Icons.shopping_cart, "screen": Order()},
    ];

    if (_isAdmin) {
      items.addAll([
        {"title": "Review", "icon": Icons.comment, "screen": ReviewScreen()},
        {"title": "Products", "icon": Icons.list, "screen": ProductsManage()},
        {"title": "Users", "icon": Icons.people, "screen": UserList()},
      ]);
    }

    return items;
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await _googleSignIn.signOut();
    await _authController.clearUser();
    setState(() => _isLoading = false);
  }

  Widget _buildDashboardItem(Map<String, dynamic> menuItem) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(menuItem["screen"], transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: Row(
            children: [
              Icon(menuItem["icon"], color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  menuItem["title"],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(icon: Icons.dashboard, iconColor: Colors.blue, title: "Dashboard"),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _dashboardItems.map(_buildDashboardItem).toList(),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _handleLogout,
            icon: _isLoading
                ? const SizedBox(
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
              backgroundColor: _isLoading ? Colors.grey : Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
      ],
    );
  }
}
