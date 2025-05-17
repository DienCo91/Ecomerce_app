import 'package:flutter/material.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/cart_all_user_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/order/index.dart';
import 'package:flutter_app/services/cart_services.dart';
import 'package:flutter_app/services/order_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({super.key, required this.totalPrice, required this.listProductByUser});

  final num totalPrice;
  final List<Products> listProductByUser;

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  bool isLoading = false;
  final CartAllUserController myCart = Get.find();
  final AuthController user = Get.find();

  void handleShowOrderSuccess(String orderId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetsLottie.orderSuccess,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
              const SizedBox(height: 16),
              const Text(
                "Thank you for your order.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: "Order ",
                  children: [
                    TextSpan(text: "#$orderId", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " is complete."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.to(Order());
                    },
                    child: const Text("Manage Orders"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleOrder(List<Products> listProductByUser) async {
    setState(() {
      isLoading = true;
    });
    try {
      await OrderService().paymentOrder(amount: calculateAmount(widget.totalPrice.toString()), currency: 'usd');
      num totalPrice = listProductByUser.fold(0, (pre, curr) => pre + curr.price);
      final cartId = await CartServices().addCartToOrder(listProductByUser);
      final orderId = await OrderService().addOrder(cartId: cartId, total: totalPrice.toInt());
      myCart.clearCartOfUser(user.user.value!.user.id);
      handleShowOrderSuccess(orderId);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Free Ship", style: TextStyle(fontSize: 16, color: Colors.redAccent)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: \$ ${widget.totalPrice}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: isLoading ? null : () => handleOrder(widget.listProductByUser),
                child:
                    isLoading
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("Placing...", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        )
                        : const Text("Place Order", style: TextStyle(fontSize: 16, color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
