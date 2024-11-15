import 'package:flutter/material.dart';

class RowBuilder extends StatefulWidget {
  const RowBuilder({super.key});

  @override
  State<RowBuilder> createState() => _RowBuilderState();
}

class _RowBuilderState extends State<RowBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.green,
    );
  }
}
