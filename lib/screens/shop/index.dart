import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/shop/widgets/carousel_slider.dart';
import 'package:flutter_app/screens/shop/widgets/category.dart';
import 'package:flutter_app/screens/shop/widgets/product.dart';
import 'package:flutter_app/screens/shop/widgets/search.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required String title}) : _title = title;

  final String _title;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Products> _products = [];
  int _currentPage = 1;
  bool _isLoadMore = true;
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();
  Map<String, dynamic> filterParams = {
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

  void _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ProductService().fetchProducts(filterParams);
      setState(() {
        _products =
            filterParams["page"] != 1
                ? [..._products, ...response.products]
                : response.products;
        _currentPage = response.currentPage;
        _isLoadMore = response.products.length < 10 ? false : true;
      });
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProducts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        _isLoading == false &&
        _isLoadMore == true) {
      filterParams["page"] = _currentPage + 1;
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Search(title: widget._title),
              Carousel(),
              Category(),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 8),
                child: Column(
                  children: [
                    Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.only(bottom: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_isLoading && index >= _products.length) {
                  return Skeletonizer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("123213123123"),
                                  Text("12321112323"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final Products p = _products[index];
                return Product(key: ValueKey(p.id), product: p);
              },
              childCount: _isLoading ? _products.length + 4 : _products.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8, // khoảng cách dọc
              crossAxisSpacing: 8, // khoảng cách ngang
              childAspectRatio: 0.6, // tùy chỉnh tỷ lệ rộng/cao
            ),
          ),
        ),
      ],
    );
  }
}
