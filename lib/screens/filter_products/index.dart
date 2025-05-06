import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/filter_products/widgets/list_products.dart';
import 'package:flutter_app/screens/filter_products/widgets/search_products.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class FilterProducts extends StatefulWidget {
  const FilterProducts({super.key});

  @override
  State<FilterProducts> createState() => _FilterProductsState();
}

class _FilterProductsState extends State<FilterProducts> {
  late String _txtSearch;
  List<Products> _products = [];
  bool _isLoading = true;
  int _currentPage = 1;
  bool _isLoadMore = true;
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> filterParams = {
    "name": "all",
    "category": "all",
    "brand": "all",
    "min": 1,
    "max": 2500,
    "rating": 0,
    "order": 0,
    "page": 1,
    "limit": 10,
    "sortOrder": jsonEncode({"_id": -1}),
  };

  void getProducts(Map<String, dynamic> params) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ProductService().fetchProducts(filterParams);
      setState(() {
        _products = filterParams["page"] != 1 ? [..._products, ...response.products] : response.products;
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

  void _handleLoadMore() {
    if (!_isLoadMore) return;
    filterParams["page"] = _currentPage + 1;
    getProducts(filterParams);
  }

  void _handleSearchFilter(
    String searchTxt,
    Map<String, num> selectedValue,
    RangeValues currentRangeValues,
    double rating,
  ) {
    setState(() {
      filterParams["name"] = searchTxt.isEmpty ? 'all' : searchTxt;
      filterParams["min"] = currentRangeValues.start.toInt();
      filterParams["max"] = currentRangeValues.end.toInt();
      filterParams["rating"] = rating.toInt();
      filterParams["order"] = 0;
      if (selectedValue.isNotEmpty) filterParams["sortOrder"] = jsonEncode(selectedValue);
      filterParams["page"] = 1;
      _currentPage = 1;
      _products = [];
    });
    getProducts(filterParams);
    _scrollController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void _handleToggleFavorite(bool isLiked, String productId) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index].isLiked = isLiked;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _txtSearch = Get.arguments.toString().trim();
    filterParams["name"] = _txtSearch.isEmpty ? 'all' : _txtSearch;
    getProducts(filterParams);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: AppScaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Column(
          children: [
            SearchProducts(txtSearch: _txtSearch, handleSearchFilter: _handleSearchFilter),
            SizedBox(height: 24),
            ListProducts(
              products: _products,
              isLoading: _isLoading,
              handleLoadMore: _handleLoadMore,
              scrollController: _scrollController,
              onToggleFavorite: _handleToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
