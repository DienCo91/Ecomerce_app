import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/cart_all_user_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/card_by_user/widgets/item_card.dart';
import 'package:flutter_app/screens/card_by_user/widgets/place_order.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CardByUser extends StatefulWidget {
  const CardByUser({super.key});

  @override
  State<CardByUser> createState() => _CardByUserState();
}

class _CardByUserState extends State<CardByUser> {
  late CartAllUserController myCart;
  final AuthController user = Get.find();
  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => CartAllUserController());
    myCart = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    void onDelete(String prodId) {
      myCart.removeFromCart(user.user.value!.user.id, prodId);
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
                  child: PlaceOrder(totalPrice: totalPrice, listProductByUser: listProductByUser),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
