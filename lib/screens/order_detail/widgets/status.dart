import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/order_controller.dart';
import 'package:flutter_app/services/order_service.dart';
import 'package:flutter_app/utils/color.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get/get.dart';

List<String> statusOptions = ['Not processed', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

class Status extends StatefulWidget {
  const Status({
    super.key,
    this.isAdmin = false,
    required this.status,
    required this.cartId,
    required this.orderId,
    required this.productId,
  });

  final bool isAdmin;
  final String status;
  final String cartId;
  final String orderId;
  final String productId;

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late String status;
  bool isLoading = false;
  OrderController orderController = Get.find();

  void onChanged(String? newStatus) async {
    if (newStatus == null) return;

    setState(() {
      isLoading = true;
    });
    try {
      await OrderService().updateStatusOrder(
        orderId: widget.orderId,
        cartId: widget.cartId,
        status: newStatus,
        productId: widget.productId,
      );
      orderController.updateOrderStatus(widget.orderId, newStatus);
      setState(() {
        status = newStatus;
      });

      showSnackBar(message: "Update Success");
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Status:", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        widget.isAdmin
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: getStatusColor(status), borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      dropdownColor: getStatusColor(status),
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      onChanged: isLoading ? null : onChanged,
                      items:
                          statusOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
            )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: getStatusColor(status), borderRadius: BorderRadius.circular(8.0)),
              child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
      ],
    );
  }
}
