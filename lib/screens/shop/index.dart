import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/shop/widgets/carousel_slider.dart';
import 'package:flutter_app/screens/shop/widgets/search.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:flutter_app/widgets/product.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required this.title});
  final String title;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final ScrollController _scrollController = ScrollController();
  final List<Products> _products = [];
  int _currentPage = 1;
  bool _canLoadMore = true;
  bool _isLoading = false;

  final Map<String, dynamic> _filterParams = {
    "name": "all",
    "category": "all",
    "brand": "all",
    "min": 1,
    "max": 5000,
    "rating": 0,
    "order": 0,
    "page": 1,
    "limit": 10,
    "sortOrder": jsonEncode({"_id": -1}),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _canLoadMore) {
      _filterParams["page"] = ++_currentPage;
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      final response = await ProductService().fetchProducts(_filterParams);
      final List<Products> fetched = response.products.where((p) => p.isActive).toList();

      setState(() {
        if (_filterParams["page"] == 1) {
          _products.clear();
        }
        _products.addAll(fetched);
        _canLoadMore = fetched.length == _filterParams["limit"];
      });
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateFavorite(bool isLiked, String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      setState(() {
        _products[index].isLiked = isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Search(title: widget.title),
              const Carousel(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              if (_products.isEmpty && !_isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No products found"))),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_isLoading && index >= _products.length) {
                  return const SkeletonProductCard();
                }

                final product = _products[index];
                return Product(
                  key: ValueKey(product.id),
                  product: product,
                  isShowHeart: true,
                  onToggleFavorite: _updateFavorite,
                );
              },
              childCount: _isLoading ? _products.length + 4 : _products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: double.infinity, height: 200, color: Colors.grey[300]),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Loading..."), Text("Please wait")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
