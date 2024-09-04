import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomH1Title extends StatelessWidget {
  final String text;

  const CustomH1Title({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textWidthBasis: TextWidthBasis.longestLine,
          textAlign: TextAlign.left,
          softWrap: true,
          text: TextSpan(children: [
            TextSpan(
                text:
                    "${text.toUpperCase().split(" ").sublist(0, text.split(" ").length - 1).join(" ")} ",
                style: GoogleFonts.raleway(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                )),
            TextSpan(
              text: "\u{00A0}${text.toUpperCase().split(" ").last}\u{00A0}",
              style: GoogleFonts.raleway(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  background: Paint()
                    ..color = const Color.fromRGBO(255, 81, 81, 1)
                    ..strokeWidth = 18
                    ..style = PaintingStyle.stroke
                    ..style = PaintingStyle.fill),
            )
          ])),
    );
  }
}
