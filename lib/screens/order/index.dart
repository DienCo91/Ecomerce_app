import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/order/widgets/my_order.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthController authController = Get.put(AuthController());

  late bool isAdmin;

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    final user = authController.user.value;
    isAdmin = user != null && user.user.role == "ROLE ADMIN";

    _tabs =
        isAdmin
            ? const [KeepAliveWrapper(child: MyOrder()), KeepAliveWrapper(child: MyOrder(isAllOrder: true))]
            : const [KeepAliveWrapper(child: MyOrder())];

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.shopping_bag_outlined, size: 20), SizedBox(width: 8), Text("My Order")],
              ),
            ),
            if (isAdmin)
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.list_alt_outlined, size: 20), SizedBox(width: 8), Text("Customer Order")],
                ),
              ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, physics: const ClampingScrollPhysics(), children: _tabs),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
