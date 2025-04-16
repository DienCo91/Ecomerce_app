import 'package:flutter/material.dart';

class TextFiledCustom extends StatefulWidget {
  const TextFiledCustom({
    super.key,
    required this.labelTxt,
    required this.isObscureText,
  });
  final String labelTxt;
  final bool isObscureText;

  @override
  State<TextFiledCustom> createState() => _TextFiledCustom();
}

class _TextFiledCustom extends State<TextFiledCustom> {
  late TextEditingController _controller;
  late TextEditingController _controller2;
  late FocusNode _focusNode2;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            obscureText: widget.isObscureText,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: widget.labelTxt,
              labelStyle: TextStyle(
                color: const Color.fromARGB(255, 182, 58, 253),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 182, 58, 253),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 182, 58, 253),
                ),
              ),
            ),
            onSubmitted: (value) => _focusNode2.requestFocus(),
          ),
          TextField(controller: _controller2, focusNode: _focusNode2),
          ElevatedButton(
            onPressed: () => print(_controller.text),
            child: Text("Print Text"),
          ),
          ElevatedButton(
            onPressed: () => _controller.clear(),
            child: Text("Clear"),
          ),
        ],
      ),
    );
  }
}
