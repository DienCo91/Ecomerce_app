import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/products.dart';
import 'package:flutter_app/screens/filter_products/widgets/filter.dart';
import 'package:flutter_app/services/suggest_search_service.dart';

class SearchProducts extends StatefulWidget {
  const SearchProducts({super.key});

  @override
  State<SearchProducts> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  OverlayEntry? _overlayEntry;
  List<Products> _suggestions = [];
  Timer? _debounce;
  TextEditingController _searchController = TextEditingController();

  void _handleSuggestion(String name) async {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final response = await SuggestSearchService().getSuggestions(name);
        setState(() {
          _suggestions = response;
          if (_overlayEntry != null) {
            _overlayEntry!.markNeedsBuild();
          }
        });
      } catch (e) {
        print("Error fetching suggestions: $e");
      }
    });
  }

  void _onChanged(String value) {
    if (value.trim().isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _handleSuggestion(value);
      if (_overlayEntry == null) {
        _showOverLay(context);
      }
    }
  }

  void _disableOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    FocusScope.of(context).unfocus();
  }

  void _showOverLay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                top: 80,
                child: GestureDetector(
                  onTap: _disableOverlay,
                  child: Container(color: const Color.fromARGB(0, 0, 0, 0)),
                ),
              ),
              Positioned(
                top: 86,
                left: 100,
                right: 20,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(4),
                  shadowColor: Colors.black,
                  color: Colors.white,
                  child: Container(
                    width: 180,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ..._suggestions.map((e) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(e.name),
                                  ),
                                  onTap: () {
                                    _searchController.value = TextEditingValue(
                                      text: e.name,
                                    );
                                    _overlayEntry?.remove();
                                    _overlayEntry = null;
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context, debugRequiredFor: widget).insert(_overlayEntry!);
  }

  void handleSearch() {
    if (_searchController.text.isNotEmpty) {
      _disableOverlay();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Filter Products",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Filter(),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 14),
                onChanged: _onChanged,
                onSubmitted: (value) => handleSearch(),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    left: 20,
                    right: 20,
                  ),
                  hintText: "Search ...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: handleSearch,
                    icon: Icon(Icons.search, color: Colors.blue, size: 24),
                  ),
                  fillColor: const Color.fromARGB(48, 158, 158, 158),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
