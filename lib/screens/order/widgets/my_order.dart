import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/order_controller.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/screens/order/widgets/order_item.dart';
import 'package:flutter_app/services/order_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key, this.isAllOrder});

  final bool? isAllOrder;

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  late OrderController orderController;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    orderController = Get.put(OrderController());
    authController = Get.put(AuthController());

    _fetchOrders(orderController);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoading && _hasMore) {
          _fetchOrders(orderController);
        }
      }
    });
  }

  Future<void> _fetchOrders(OrderController orderController) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final orderResponse =
          widget.isAllOrder == true
              ? await OrderService().getOrderAll(page: _page, limit: _pageSize)
              : await OrderService().getOrderByUser(page: _page, limit: _pageSize);
      final newOrders = orderResponse.orders;
      final filteredOrders = newOrders.where((order) => order.products.isNotEmpty).toList();

      if (widget.isAllOrder == true) {
        orderController.orderAll.addAll(filteredOrders);
      } else {
        orderController.orders.addAll(filteredOrders);
      }
      _page++;
      if (newOrders.length < _pageSize) _hasMore = false;
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<OrderController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          List<Orders> orders = widget.isAllOrder == true ? orderController.orderAll : orderController.orders;
          if (orders.isEmpty && !_isLoading) {
            return Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      AssetsLottie.orderEmpty,
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                    Text(
                      "Order Empty!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              controller: _scrollController,
              itemCount: orders.length + (_isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index >= orders.length) {
                  return Skeletonizer(enabled: _isLoading, child: OrderItem());
                }

                final order = orders[index];
                final String status = order.products.isNotEmpty ? order.products.first.status : "Unknown";
                if (order.products.isEmpty) return SizedBox();
                return OrderItem(
                  order: order,
                  status: status,
                  isEdit: authController.user.value?.user.role == "ROLE ADMIN",
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
