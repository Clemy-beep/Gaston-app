import 'package:flutter/material.dart';

class InputNumberWidget extends StatelessWidget {
  final String labelText;
  final double width;
  final double height;
  final void Function(String?) onChanged;

  const InputNumberWidget(
      {super.key,
      this.width = 300,
      required this.labelText,
      this.height = 50,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color.fromRGBO(
          255, 201, 201, 1), // Couleur de fond personnalisée
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true, // Permet de remplir le background du TextField
          fillColor: const Color.fromARGB(
              255, 248, 84, 84), // Couleur de remplissage du TextField
        ),
      ),
    );
  }
}
