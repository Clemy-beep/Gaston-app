import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double width;
  final int maxlines;
  final void Function(String?) onChanged;
  final bool obscureText;

  const CustomTextInput(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.width = 300.0,
      this.maxlines = 1,
      this.obscureText = false,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        onChanged: onChanged,
        maxLines: maxlines,
        obscureText: obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none),
            labelText: labelText,
            hintText: hintText,
            hintStyle: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(73, 73, 73, 1)),
            filled: true, // Permet de remplir le background du TextField
            fillColor: const Color.fromRGBO(
                255, 201, 201, 1) // Couleur de remplissage du TextField
            ),
      ),
    );
  }
}
