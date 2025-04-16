import 'package:flutter/material.dart';
import 'package:flutter_app/providers/app_state.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorite = appState.favorite;
    var theme = Theme.of(context);

    if (favorite.isEmpty) {
      return Center(child: Text('No favorites yet!'));
    }

    return ListView(
      children:
          favorite.map((pair) {
            return ListTile(
              title: Text(pair.asPascalCase),
              leading: Icon(Icons.favorite),
              iconColor: theme.colorScheme.secondary,
              trailing: IconButton(
                onPressed: () {
                  appState.removeFavorite(pair);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            );
          }).toList(),
    );
  }
}
