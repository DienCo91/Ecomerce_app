import 'package:flutter/material.dart';
import 'package:flutter_app/screens/favorote_page.dart';
import 'package:flutter_app/screens/generator_page.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [GeneratorPage(), FavoritePage()];

    return LayoutBuilder(
      builder: (context, constraints) {
        return AppScaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text("Favorites"),
                    ),
                  ],
                  selectedIndex: selectIndex,
                  onDestinationSelected:
                      (value) => {
                        setState(() {
                          selectIndex = value;
                        }),
                      },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: IndexedStack(index: selectIndex, children: pages),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/learn');
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
