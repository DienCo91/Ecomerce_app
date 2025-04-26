import 'package:flutter/material.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/services/category_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Categories> _category = [];
  bool _isLoading = true;

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    try {
      final response = await CategoryService().getCategories();

      setState(() {
        _category = response;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Skeletonizer(
            enabled: _isLoading,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _isLoading ? 4 : _category.length,

                itemBuilder: (context, index) {
                  String name =
                      _category.length > 0 && _category[index].name.isNotEmpty
                          ? _category[index].name
                          : "";
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    constraints: const BoxConstraints(maxWidth: 80),
                    child: FilledButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.blue,
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
