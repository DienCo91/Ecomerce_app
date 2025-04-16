// lib/widgets/app_scaffold.dart
import 'package:flutter/material.dart';

class AppScaffold extends Scaffold {
  AppScaffold({
    super.key,
    required Widget body,
    String title = 'Flutter App',
    PreferredSizeWidget? appBar,
    Widget? drawer,
    Widget? bottomNavigationBar,
    FloatingActionButton? floatingActionButton,
    bool resizeToAvoidBottomInset = true,
  }) : super(
         appBar: appBar ?? AppBar(title: Text(title)),
         body: Container(
           padding: EdgeInsets.only(left: 16, right: 16),
           child: body,
         ),
         drawer: drawer,
         bottomNavigationBar: bottomNavigationBar,
         floatingActionButton: floatingActionButton,
         resizeToAvoidBottomInset: resizeToAvoidBottomInset,
       );
}
