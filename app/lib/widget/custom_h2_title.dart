import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomH2Title extends StatelessWidget {
  const CustomH2Title({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.raleway(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ));
  }
}
