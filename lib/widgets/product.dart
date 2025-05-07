import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/detail_products/index.dart';
import 'package:flutter_app/services/wishlist_services.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:get/get.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.product, this.isShowHeart = false, this.onToggleFavorite});
  final Products product;
  final bool? isShowHeart;
  final Function(bool isLiked, String id)? onToggleFavorite;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  double _scale = 1;
  bool _isFavorite = false;

  void onTap() async {
    await Future.delayed(Duration(milliseconds: 200));
    Get.to(() => DetailProduct(), arguments: widget.product);
  }

  double get targetScale => _isFavorite ? 1.6 : 1.0;

  void onLiked() async {
    final isActiveScale = _isFavorite == false;
    try {
      String res = await WishlistServices().toggleFavorite(!_isFavorite, widget.product.id);

      showSnackBar(message: res, duration: 2);

      setState(() {
        _isFavorite = !_isFavorite;
        if (isActiveScale) {
          _scale = 1.6;
        }
      });

      if (widget.onToggleFavorite != null) {
        widget.onToggleFavorite!(_isFavorite, widget.product.id);
      }

      if (isActiveScale) {
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          _scale = 1.0;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _scale = 1;
    _isFavorite = widget.product.isLiked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      shadowColor: const Color.fromARGB(103, 0, 0, 0),
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: FadeInImage(
                  placeholder: AssetsImages.defaultImage,
                  image: NetworkImage('${ApiConstants.baseUrl}${widget.product.imageUrl}'),
                  fit: BoxFit.contain,
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
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'By ${widget.product.brand.name}',
                        style: TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.product.description,
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${widget.product.price}',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: const Color.fromARGB(19, 33, 149, 243),
                highlightColor: const Color.fromARGB(19, 33, 149, 243),
              ),
            ),
          ),
          widget.isShowHeart == true
              ? Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: onLiked,
                  child: AnimatedScale(
                    scale: _scale,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        Icons.favorite,
                        key: ValueKey(_isFavorite),
                        color: _isFavorite ? Colors.red : Colors.grey[300],
                        size: 28,
                      ),
                    ),
                  ),
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
