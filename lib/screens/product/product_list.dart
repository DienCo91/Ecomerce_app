import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Danh sách sản phẩm')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ListTile(
                  leading: Image.network(product.imageUrl, width: 50),
                  title: Text(product.name),
                  subtitle: Text('${product.price.toStringAsFixed(2)} VNĐ'),
                );
              },
            ),
    );
  }
}
