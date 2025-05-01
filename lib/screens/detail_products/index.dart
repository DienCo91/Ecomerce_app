import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/detail_products/widgets/comment.dart';
import 'package:flutter_app/screens/detail_products/widgets/divider.dart';
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
  final Products productDetail = Get.arguments;
  int quantity = 1;

  void onAddQuantity() {
    if (quantity < productDetail.quantity) {
      setState(() {
        quantity += 1;
      });
    }
  }

  void onRemoveQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity -= 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 420,
                  child: Stack(
                    children: [
                      FadeInImage(
                        placeholder: AssetsImages.defaultImage,
                        image: NetworkImage('${ApiConstants.baseUrl}${productDetail.imageUrl}'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image(
                            image: AssetsImages.defaultImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        top: 30,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100),
                            ),
                            color: Colors.blue,
                          ),
                          child: Text("In Stock", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$ ${formatter.format(productDetail.price * quantity)}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          productDetail.name,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        productDetail.description,
                        style: TextStyle(color: const Color.fromARGB(112, 0, 0, 0), fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text("Brand:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.only(top: 0, bottom: 0))),
                            child: Text(productDetail.brand.name, style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Quantity :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              IconButton(onPressed: quantity > 1 ? onRemoveQuantity : null, icon: Icon(Icons.remove)),
                              Text('$quantity'),
                              IconButton(
                                onPressed: quantity < productDetail.quantity ? onAddQuantity : null,
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 8),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.shopping_cart, size: 24, color: Colors.white),
                          onPressed: () {},
                          label: Text(
                            "Add To Card",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ),
                DividerCustom(),
                ReviewProduct(name: productDetail.name),
                DividerCustom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
