import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/app_state.dart';
import 'package:flutter_app/widgets/big_card.dart';
import 'package:flutter_app/widgets/list_center.dart';
import 'package:provider/provider.dart';

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  var listName = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    String label;
    IconData icon;
    if (appState.favorite.contains(pair)) {
      icon = Icons.favorite;
      label = "Unlike";
    } else {
      icon = Icons.favorite_border;
      label = "Like";
    }
    print(listName);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListCenter(listName: listName, appState: appState),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text(label),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNew();
                  setState(() {
                    listName.add(pair);
                  });
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
