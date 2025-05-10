import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/order_controller.dart';
import 'package:flutter_app/models/orders.dart';
import 'package:flutter_app/screens/order_detail/widgets/order_item_cart.dart';
import 'package:flutter_app/screens/order_detail/widgets/order_summary_section.dart';
import 'package:flutter_app/screens/order_detail/widgets/status.dart';
import 'package:flutter_app/services/order_service.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:get/get.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Orders? order;
  String? status;
  bool? isAllOrder;
  bool _isLoading = false;
  late OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Get.find();
    final args = Get.arguments as Map<String, dynamic>;
    order = args['order'] as Orders?;
    status = args['status'] as String?;
    isAllOrder = args['isAllOrder'] as bool?;
  }

  void handleDeleteOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await OrderService().deleteOrder(orderId: order!.id);
      isAllOrder == true ? orderController.deleteOrderAll(order!.id) : orderController.deleteOrder(order!.id);
      Get.back();
      Get.back();
      showSnackBar(message: "Cancel Order Success!");
    } catch (e) {
      print("e $e");
    } finally {
      _isLoading = false;
    }
  }

  void showCancelOrderDialog() {
    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Cancel Order", style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text("Are you sure you want to cancel this order?", textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          Get.back();
                        },
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          handleDeleteOrder();
                          setSheetState(() {
                            _isLoading = true;
                          });
                        },
                child: Text("Cancel Order", style: TextStyle(color: _isLoading ? Colors.grey : Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (order == null || status == null) {
      return const Scaffold(body: Center(child: Text("Empty")));
    }

    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(icon: Icons.local_mall, iconColor: Colors.blue, title: "Order Details"),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              shadowColor: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order != null)
                      Status(
                        status: status ?? "",
                        isAdmin: isAllOrder ?? false,
                        cartId: order?.cartId ?? "",
                        orderId: order?.id ?? "",
                        productId: order?.products[0].id ?? "",
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Order ID: ${order!.id}",
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Order Date: ${formatDate(order!.created)}",
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Order Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order!.products.map((item) => OrderItemCard(item: item)),
            const SizedBox(height: 24),
            const Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OrderSummarySection(order: order!),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton.icon(
                onPressed: showCancelOrderDialog,
                label: Text("Cancel Order".toUpperCase(), style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  overlayColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
