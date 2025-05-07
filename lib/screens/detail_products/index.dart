import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/cart_all_user_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/detail_products/widgets/divider.dart';
import 'package:flutter_app/screens/detail_products/widgets/icon_cart_number.dart';
import 'package:flutter_app/screens/detail_products/widgets/review.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/utils/string.dart';
import 'package:get/get.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final Products productDetail = Get.arguments;
  int quantity = 1;

  void onAddQuantity() {
    if (quantity < productDetail.quantity) {
      setState(() {
        quantity += 1;
      });
    }
  }

  void onRemoveQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity -= 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => CartAllUserController());
  }

  @override
  Widget build(BuildContext context) {
    final CartAllUserController cardAllUser = Get.find();
    final AuthController user = Get.find();

    void handleAddToCard() async {
      await Future.delayed(Duration(seconds: 1));
      final currentUser = user.user.value?.user;
      if (currentUser != null) {
        final updateProduct = productDetail.copyWith(quantity: quantity, price: quantity * productDetail.price);
        cardAllUser.addToCart(currentUser.id, updateProduct);
        Get.snackbar(
          "Add Success !",
          "Add product to cart",
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
          duration: const Duration(seconds: 3),
          forwardAnimationCurve: Curves.easeIn,
          reverseAnimationCurve: Curves.easeIn,
        );
      }
    }

    void handleRemoveToCard() async {
      await Future.delayed(Duration(seconds: 1));
      final currentUser = user.user.value?.user;
      if (currentUser != null) {
        cardAllUser.removeFromCart(currentUser.id, productDetail.id);
        Get.snackbar(
          "Remove Success !",
          "Remove product to cart",
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
          duration: const Duration(seconds: 3),
          forwardAnimationCurve: Curves.easeIn,
          reverseAnimationCurve: Curves.easeIn,
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 420,
                  child: Stack(
                    children: [
                      FadeInImage(
                        placeholder: AssetsImages.defaultImage,
                        image: NetworkImage('${ApiConstants.baseUrl}${productDetail.imageUrl}'),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image(
                            image: AssetsImages.defaultImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        top: 30,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100),
                            ),
                            color: productDetail.quantity >= 1 ? Colors.blue : Colors.red,
                          ),
                          child: Text(
                            productDetail.quantity >= 1 ? "In stock" : "Out of stock",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Obx(() => IconCardNumber(number: cardAllUser.getCartByUser(user.user.value!.user.id).length)),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$ ${formatter.format(productDetail.price * quantity)}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          productDetail.name,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        productDetail.description,
                        style: TextStyle(color: const Color.fromARGB(112, 0, 0, 0), fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Text("Brand:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(productDetail.brand.name, style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Quantity :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              IconButton(onPressed: quantity > 1 ? onRemoveQuantity : null, icon: Icon(Icons.remove)),
                              Text('$quantity'),
                              IconButton(
                                onPressed: quantity < productDetail.quantity ? onAddQuantity : null,
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),

                      productDetail.quantity >= 1
                          ? Obx(() {
                            final userId = user.user.value?.user.id ?? '';
                            bool hasProductInCart = cardAllUser.hasProductInCart(userId, productDetail.id);
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 8),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.shopping_cart, size: 24, color: Colors.white),
                                onPressed: () {
                                  if (hasProductInCart) {
                                    handleRemoveToCard();
                                  } else {
                                    handleAddToCard();
                                  }
                                },
                                label: Text(
                                  hasProductInCart ? "Remove To Cart" : "Add To Cart",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    hasProductInCart ? Colors.red[400] : Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          })
                          : SizedBox(),
                    ],
                  ),
                ),
                DividerCustom(),
                ReviewProduct(name: productDetail.name, id: productDetail.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
