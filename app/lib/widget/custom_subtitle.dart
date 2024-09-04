import 'package:flutter/material.dart';

class CustomSubtitle extends StatelessWidget {
  const CustomSubtitle({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.italic,
          color: Colors.black,
        ),
      ),
    );
  }
}
