import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double width;
  final double height;
  final void Function(String?) onChanged;

  const InputTextWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.width = 300.0,
      this.height = 60.0,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color.fromRGBO(
          255, 239, 239, 1), // Couleur de fond personnalisée
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          filled: true, // Permet de remplir le background du TextField
          fillColor: const Color.fromRGBO(
              255, 201, 201, 1), // Couleur de remplissage du TextField
        ),
      ),
    );
  }
}
