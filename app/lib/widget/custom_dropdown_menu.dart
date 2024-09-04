import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomDropdownMenu extends StatefulWidget {
  CustomDropdownMenu(
      {super.key,
      required this.onChanged,
      required this.items,
      required this.hint,
      required this.dropdownValue,});

  final List<DropdownItem> items;
  final String hint;
  final void Function(int?) onChanged;

  int dropdownValue;
  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: const Color.fromRGBO(255, 201, 201, 1)),
      child: DropdownButton(
        underline:
            Container(height: 0, color: const Color.fromRGBO(0, 0, 0, 0)),
        dropdownColor: const Color.fromRGBO(255, 201, 201, 1),
        hint: Text(widget.hint),
        value: widget.dropdownValue,
        icon: const Icon(Icons.expand_more),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        style: GoogleFonts.raleway(color: const Color.fromRGBO(1, 1, 1, 1)),
        focusColor: Colors.transparent,
        items: widget.items
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: (int? newValue) {
          setState(() {
            widget.dropdownValue = newValue!;
            widget.onChanged(newValue);
          });
        },
      ),
    );
  }
}

class DropdownItem {
  final int key;
  final String value;

  DropdownItem(this.key, this.value);
}
