import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/ElevationButtonCustom.dart';
import 'package:flutter_app/widgets/line_or.dart';
import 'package:flutter_app/widgets/outline_button_custom.dart';
import 'package:flutter_app/widgets/richtext_custom.dart';
import 'package:flutter_app/widgets/text_field_custom.dart';
import 'package:flutter_app/widgets/text_shadow.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo Scaffold')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextShadowCustom(),
                SelectableText("From forth the fatal loins of these two foes"),
                RichTextCustom(),
                ElevatedButtonCustom(isPress: true),
                LineOr(),
                OutlineButtonCustom(),
                TextFiledCustom(labelTxt: "Password", isObscureText: true),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/form"),
                  child: Text("To Form Page"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
