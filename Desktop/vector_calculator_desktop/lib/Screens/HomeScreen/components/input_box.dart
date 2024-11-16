import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    required this.hintText,
    required this.onValueChanged,
  });

  final String hintText;
  final Function(String) onValueChanged;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 263,
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onValueChanged, // Notify parent on change
        decoration: InputDecoration(
          hintText: widget.hintText, // Display hint text as (x, y, z)
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 24, color: Colors.black),
        ),
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
