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
  final AuthController _authControllerInstance = Get.put(AuthController());
  late PageController _pageController;
  int _currentTabIndex = 0;

  final Map<int, Widget> _tabScreens = {
    0: Shop(title: "Shop"),
    1: Wishlist(),
    2: CardByUser(),
    3: DashBoard(),
  };

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Shop"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Card"),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    if (initialFirebaseMessage != null) {
      Future.microtask(() {
        FirebaseApi().handleMessage(initialFirebaseMessage!);
        initialFirebaseMessage = null;
      });
    }

    final dynamic receivedArgs = Get.arguments;
    if (receivedArgs != null && receivedArgs is Map && receivedArgs['tabIndex'] is int) {
      _currentTabIndex = receivedArgs['tabIndex'];
      _pageController = PageController(initialPage: _currentTabIndex);
    }
  }

  void _onNavigationBarItemTapped(int index) {
    if (_currentTabIndex != index) {
      setState(() {
        _currentTabIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
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
        currentIndex: _currentTabIndex,
        onTap: _onNavigationBarItemTapped,
        selectedItemColor: Colors.blue[500],
        unselectedItemColor: const Color.fromARGB(104, 0, 0, 0),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: _bottomNavItems,
      ),
    );
  }

  Widget _getTabBody() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tabScreens.length,
      itemBuilder: (context, index) {
        return Center(child: _tabScreens[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: _getTabBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
