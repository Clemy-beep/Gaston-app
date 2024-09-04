import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMainActionButton extends StatelessWidget {
  const CustomMainActionButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.icon});
  final void Function() onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 81, 81, 1),
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 3,
              offset: Offset(0, 4),
              color: Color.fromRGBO(0, 0, 0, 0.25),
            )
          ]),
      height: 60,
      child: ElevatedButton(
          onPressed: onPressed,
          // ignore: prefer_const_constructors
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromRGBO(255, 81, 81, 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.black,
              ),
              const Padding(padding: EdgeInsets.only(left: 4.0)),
              Text(
                text,
                style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w200),
              ),
            ],
          )),
    );
  }
}
