import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/product_manager_controller.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/product_manage_detail/index.dart';
import 'package:flutter_app/screens/products_manage/widgets/item.dart';
import 'package:flutter_app/services/product_service.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsManage extends StatefulWidget {
  const ProductsManage({super.key});

  @override
  State<ProductsManage> createState() => _ProductsManageState();
}

class _ProductsManageState extends State<ProductsManage> {
  late ProductManagerController productManagerController;
  bool _isLoading = false;

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ProductService().fetchAllProducts();
      response.sort((a, b) => b.created.compareTo(a.created));
      productManagerController.products.addAll(response);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleNavigateDetail() {
    Get.to(ProductManageDetail(), arguments: {'type': DetailType.add});
  }

  @override
  void initState() {
    super.initState();
    productManagerController = Get.put(ProductManagerController());
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    productManagerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(icon: Icons.list, title: "Products", iconColor: Colors.blue),
                ElevatedButton.icon(
                  onPressed: handleNavigateDetail,
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  label: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            final products = productManagerController.products;

            if (products.isEmpty && _isLoading == false) return Center(child: Text('Empty Product '));

            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: products.length + (_isLoading ? 2 : 0),
                padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
                itemBuilder: (context, index) {
                  if (_isLoading && index >= products.length) {
                    return Skeletonizer(enabled: _isLoading, child: Item());
                  }

                  Products product = products[index];

                  return Item(product: product);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
