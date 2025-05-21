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
  final Products product = Get.arguments;
  int quantity = 1;

  final CartAllUserController cartController = Get.put(CartAllUserController());
  final AuthController authController = Get.find();

  void incrementQuantity() {
    if (quantity < product.quantity) setState(() => quantity++);
  }

  void decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  void showSnackbar({required String title, required String message, required Color color}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeIn,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  Future<void> handleAddToCart() async {
    await Future.delayed(Duration(seconds: 1));
    final user = authController.user.value?.user;
    if (user != null) {
      final updatedProduct = product.copyWith(
        quantity: quantity,
        price: quantity * product.price,
      );
      cartController.addToCart(user.id, updatedProduct);
      showSnackbar(title: "Add Success!", message: "Product added to cart", color: Colors.greenAccent);
    }
  }

  Future<void> handleRemoveFromCart() async {
    await Future.delayed(Duration(seconds: 1));
    final user = authController.user.value?.user;
    if (user != null) {
      cartController.removeFromCart(user.id, product.id);
      showSnackbar(title: "Remove Success!", message: "Product removed from cart", color: Colors.red.shade400);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = authController.user.value?.user.id ?? '';

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
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProductImage(userId),
                buildProductInfo(userId),
                DividerCustom(),
                ReviewProduct(name: product.name, id: product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductImage(String userId) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          FadeInImage(
            placeholder: AssetsImages.defaultImage,
            image: NetworkImage('${ApiConstants.baseUrl}${product.imageUrl}'),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            imageErrorBuilder: (_, __, ___) => Image(
              image: AssetsImages.defaultImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
                color: product.quantity >= 1 ? Colors.blue : Colors.red,
              ),
              child: Text(
                product.quantity >= 1 ? "In stock" : "Out of stock",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Obx(() => IconCardNumber(
                number: cartController.getCartByUser(userId).length,
              )),
        ],
      ),
    );
  }

  Widget buildProductInfo(String userId) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$ ${formatter.format(product.price * quantity)}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(color: Color.fromARGB(112, 0, 0, 0), fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              const Text("Quantity:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  IconButton(onPressed: decrementQuantity, icon: const Icon(Icons.remove)),
                  Text('$quantity'),
                  IconButton(onPressed: incrementQuantity, icon: const Icon(Icons.add)),
                ],
              ),
            ],
          ),
          if (product.quantity >= 1)
            Obx(() {
              final hasProduct = cartController.hasProductInCart(userId, product.id);
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text(
                    hasProduct ? "Remove From Cart" : "Add To Cart",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  onPressed: hasProduct ? handleRemoveFromCart : handleAddToCart,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      hasProduct ? Colors.red.shade400 : Colors.blue,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
