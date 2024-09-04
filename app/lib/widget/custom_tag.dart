import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTag extends StatelessWidget {
  const CustomTag(
      {super.key,
      required this.text,
      required this.color,
      required this.isSelect});
  final String text;
  final String color;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelect ? Color(int.parse('0xFF$color')) : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: !isSelect
            ? Border.all(
                color: Color(int.parse('0xFF$color')),
                width: 4.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 4.0,
              ),
      ),
      child: Text(
        text,
        style: GoogleFonts.raleway(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}
