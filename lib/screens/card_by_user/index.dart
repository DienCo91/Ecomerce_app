import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/cart_all_user_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/card_by_user/widgets/item_card.dart';
import 'package:flutter_app/screens/order/index.dart';
import 'package:flutter_app/services/cart_services.dart';
import 'package:flutter_app/services/order_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CardByUser extends StatefulWidget {
  const CardByUser({super.key});

  @override
  State<CardByUser> createState() => _CardByUserState();
}

class _CardByUserState extends State<CardByUser> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => CartAllUserController());
  }

  @override
  Widget build(BuildContext context) {
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

    void onDelete(String prodId) {
      myCart.removeFromCart(user.user.value!.user.id, prodId);
    }

    void handleOrder(List<Products> listProductByUser) async {
      setState(() {
        isLoading = true;
      });
      try {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 20),
          child: Row(
            children: [
              Icon(Icons.shopping_cart, size: 30, color: Colors.blue),
              SizedBox(width: 12),
              Text("Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final List<Products> listProductByUser = myCart.getCartByUser(user.user.value!.user.id);
            final num totalPrice = listProductByUser.fold(0, (pre, curr) => pre + curr.price);
            if (listProductByUser.isEmpty) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      AssetsLottie.cartEmpty,
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                    Text(
                      "Cart Empty!",
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
              );
            }
            return Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listProductByUser.length,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemBuilder: (context, index) {
                    Products product = listProductByUser[index];
                    return ItemCard(product: product, onDelete: onDelete);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Free Ship", style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total: \$ ${totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: isLoading ? null : () => handleOrder(listProductByUser),
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
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
