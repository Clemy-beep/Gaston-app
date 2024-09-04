import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double? width;
  final double? height;
  final TextEditingController controller;
  final void Function(String)? onSearch;

  const SearchInputWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.width,
      this.height,
      required this.controller,
      required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 300,
      height: height ?? 50,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(255, 201, 201, 1)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextField(
        controller: controller,
        onChanged: (text) {
          if (text.length >= 3) {
            onSearch!(text);
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none,
          filled: true, // Permet de remplir le background du TextField
          fillColor: const Color.fromRGBO(
              255, 201, 201, 1), //leur de remplissage du TextField
          // Couleur de remplissage du TextField
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
