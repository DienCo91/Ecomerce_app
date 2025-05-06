import 'package:flutter_app/models/cart_user.dart';
import 'package:flutter_app/models/products.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartAllUserController extends GetxController {
  final _storage = GetStorage();
  final carts = <CartUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCarts();
  }

  void addToCart(String userId, Products product) {
    final index = carts.indexWhere((c) => c.userId == userId);
    if (index == -1) {
      carts.add(CartUser(userId: userId, cart: [product]));
    } else {
      carts[index].cart.add(product);
      carts.refresh();
    }
    saveCarts();
  }

  void removeFromCart(String userId, String productId) {
    final index = carts.indexWhere((c) => c.userId == userId);
    if (index != -1) {
      carts[index].cart.removeWhere((p) => p.id == productId);
      carts.refresh();
      saveCarts();
    }
  }

  bool hasProductInCart(String userId, String productId) {
    final userCart = carts.firstWhere(
      (cartUser) => cartUser.userId == userId,
      orElse: () => CartUser(userId: userId, cart: []),
    );
    return userCart.cart.any((product) => product.id == productId);
  }

  List<Products> getCartByUser(String userId) {
    return carts.firstWhereOrNull((c) => c.userId == userId)?.cart ?? [];
  }

  void saveCarts() {
    final encoded = carts.map((e) => e.toJson()).toList();
    _storage.write('cartUsers', encoded);
  }

  void loadCarts() {
    final saved = _storage.read<List>('cartUsers');
    if (saved != null) {
      carts.assignAll(saved.map((e) => CartUser.fromJson(Map<String, dynamic>.from(e))));
    }
  }

  void clearCartOfUser(String userId) {
    final index = carts.indexWhere((c) => c.userId == userId);
    if (index != -1) {
      carts[index].cart.clear();
      carts.refresh();
      saveCarts();
    }
  }
}
