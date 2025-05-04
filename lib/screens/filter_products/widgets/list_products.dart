import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/widgets/product.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({
    super.key,
    required this.products,
    required this.isLoading,
    required this.handleLoadMore,
    required this.scrollController,
    this.onToggleFavorite,
  });

  final ScrollController scrollController;
  final List products;
  final bool isLoading;
  final Function handleLoadMore;
  final Function(bool isLiked, String id)? onToggleFavorite;

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  void _scrollListener() {
    if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent - 200 &&
        !widget.isLoading) {
      widget.handleLoadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty && !widget.isLoading) {
      return const Center(child: Text("No products found"));
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        controller: widget.scrollController,
        itemCount: !widget.isLoading ? widget.products.length : widget.products.length + 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          if (widget.isLoading && index >= widget.products.length) {
            return Skeletonizer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 200, color: Colors.grey),
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("123213123123"), Text("12321112323")],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final Products p = widget.products[index];
          return Product(key: ValueKey(p.id), product: p, isShowHeart: true, onToggleFavorite: widget.onToggleFavorite);
        },
      ),
    );
  }
}
