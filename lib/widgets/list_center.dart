import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/app_state.dart';

class ListCenter extends StatelessWidget {
  const ListCenter({super.key, required this.listName, required this.appState});

  final List<WordPair> listName;
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          children:
              listName.map((name) {
                var isFavorite = appState.favorite.contains(name);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isFavorite)
                        Icon(Icons.favorite, color: Colors.redAccent),
                      Text(name.asPascalCase),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
