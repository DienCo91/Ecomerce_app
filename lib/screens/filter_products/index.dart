import 'package:flutter/material.dart';
import 'package:flutter_app/screens/filter_products/widgets/search_products.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class FilterProducts extends StatefulWidget {
  const FilterProducts({super.key});

  @override
  State<FilterProducts> createState() => _FilterProductsState();
}

class _FilterProductsState extends State<FilterProducts> {
  late String _txtSearch;

  @override
  void initState() {
    super.initState();
    _txtSearch = Get.arguments.toString();
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
        body: Column(children: [SearchProducts()]),
      ),
    );
  }
}
