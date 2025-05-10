import 'package:flutter/material.dart';

class SwitchActive extends StatelessWidget {
  const SwitchActive({super.key, required this.active, required this.handleChange});

  final bool active;
  final void Function(bool isActive) handleChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 8),
      child: Row(
        children: [
          Text('Active : ', style: TextStyle(fontWeight: FontWeight.w500)),
          Switch(value: active, activeColor: Colors.blue, onChanged: handleChange),
        ],
      ),
    );
  }
}
