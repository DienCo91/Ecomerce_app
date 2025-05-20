import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    try {
      wishlists = await WishlistServices().getWishlist();
    } catch (e) {
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromWishlist(String id) async {
    try {
      final res = await WishlistServices().toggleFavorite(false, id);
      showSnackBar(message: res, duration: 2);
      setState(() {
        wishlists.removeWhere((item) => item.product.id == id);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildHeader() => Row(
        children: const [
          Icon(Icons.favorite, size: 30, color: Colors.red),
          SizedBox(width: 12),
          Text("Wishlist", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        ],
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AssetsLottie.favoriteEmpty, width: 280, height: 280),
            const SizedBox(height: 8),
            Text("No items found", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      );

  Widget _buildList() => Skeletonizer(
        enabled: _isLoading,
        child: ListView.builder(
          itemCount: _isLoading ? 4 : wishlists.length,
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final product = _isLoading ? fakeData : wishlists[index].product;
            return ItemCard(product: product, onDelete: _removeFromWishlist, isShowQuantity: false);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading || wishlists.isNotEmpty ? _buildList() : _buildEmptyState(),
          ),
        ],
      ),
    );
  }
}
