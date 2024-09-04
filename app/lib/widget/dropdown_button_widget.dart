import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String labelText;
  final double? width;
  final double? height;
  final String? selectedValue;
  final List<String> list;
  final void Function(String?)? onChanged;

  const DropdownButtonWidget({
    super.key,
    required this.labelText,
    required this.width,
    required this.height,
    this.selectedValue,
    required this.list,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      /**
       * I'm still working on how to customize the dropdown button 
       * 
       * 
       * I want to insert colors inside the menu
       *  idk why border radius dosen't work
       */
      width: width ?? 300,
      height: height ?? 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 248, 84, 84),
          labelText: labelText,
          border: InputBorder.none,
        ),
        value: selectedValue,
        items: list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
