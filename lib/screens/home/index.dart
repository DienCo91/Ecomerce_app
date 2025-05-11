import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/Wishlist/index.dart';
import 'package:flutter_app/screens/card_by_user/index.dart';
import 'package:flutter_app/screens/dashboard/index.dart';
import 'package:flutter_app/screens/shop/index.dart';
import 'package:flutter_app/utils/firebase_api.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController user = Get.put(AuthController());
  int _selectIndex = 0;

  static const List<Widget> _widgetOption = <Widget>[Shop(title: "Shop"), Wishlist(), CardByUser(), DashBoard()];

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Shop"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Card"),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (initialFirebaseMessage != null) {
      FirebaseApi().handleMessage(initialFirebaseMessage!);
      initialFirebaseMessage = null;
    }
    if (args != null && args is Map && args['tabIndex'] != null) {
      _selectIndex = args['tabIndex'];
    }
  }

  void _onTabItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0, title: null),
      body: Center(child: _widgetOption.elementAt(_selectIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: const Color.fromARGB(35, 0, 0, 0), blurRadius: 5, spreadRadius: 0)],
        ),
        child: BottomNavigationBar(
          items: _bottomNavigationBarItems,
          onTap: _onTabItem,
          currentIndex: _selectIndex,
          selectedItemColor: Colors.blue[500],
          unselectedItemColor: const Color.fromARGB(104, 0, 0, 0),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
