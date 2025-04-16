import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final styleFirst = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 24,
      fontWeight: FontWeight.normal,
    );

    final styleSecond = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${pair.first}", style: styleFirst),
            Text("${pair.second}", style: styleSecond),
          ],
        ),
      ),
    );
  }
}
