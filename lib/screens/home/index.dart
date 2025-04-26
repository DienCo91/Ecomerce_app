import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/shop/index.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController user = Get.find();
  int _selectIndex = 0;
  dynamic message;

  static const List<Widget> _widgetOption = <Widget>[
    Shop(title: "Shop"),
    Text("Wishlist"),
    Text("Card"),
    Text("Dashboard"),
  ];

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Shop"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Card"),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
  ];

  @override
  void initState() {
    super.initState();
    message = Get.arguments;
  }

  void _onTabItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        toolbarHeight: message != null ? 20 : 0,
        title: message != null ? Text(message?.notification?.title) : null,
      ),
      body: IndexedStack(index: _selectIndex, children: _widgetOption),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(35, 0, 0, 0),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
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
