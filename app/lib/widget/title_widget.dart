import 'package:flutter/material.dart';

class Titlecomponentsassetsvisual extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const Titlecomponentsassetsvisual(
      {super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // ignore: prefer_const_constructors
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
