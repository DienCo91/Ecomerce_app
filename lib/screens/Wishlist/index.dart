import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/models/wishlist.dart';
import 'package:flutter_app/screens/card_by_user/widgets/item_card.dart';
import 'package:flutter_app/services/wishlist_services.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<Wishlists> wishlists = [];
  bool _isLoading = true;

  void getWishlist() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await WishlistServices().getWishlist();
      setState(() {
        wishlists = response;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onDelete(String id) async {
    try {
      String res = await WishlistServices().toggleFavorite(false, id);
      showSnackBar(message: res, duration: 2);
      setState(() {
        wishlists = wishlists.where((item) => item.product.id != id).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Icon(Icons.favorite, size: 30, color: Colors.red),
                SizedBox(width: 12),
                Text("Wishlist", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
          ),

          if (wishlists.isEmpty && _isLoading == false)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      AssetsLottie.favoriteEmpty,
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                    Text(
                      "Wishlist Empty!",
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
            )
          else
            Expanded(
              child: Skeletonizer(
                enabled: _isLoading,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _isLoading ? 4 : wishlists.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    if (_isLoading) {
                      return ItemCard(product: fakeData, onDelete: onDelete, isShowQuantity: false);
                    }
                    Products product = wishlists[index].product;

                    return ItemCard(product: product, onDelete: onDelete, isShowQuantity: false);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
