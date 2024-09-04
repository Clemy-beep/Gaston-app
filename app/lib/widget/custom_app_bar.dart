import 'package:app/services/router.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.links, this.text = 'Recette'});
  final List<LinkModel> links;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 4),
              blurRadius: 4.0,
            )
          ]),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomH2Title(text: text),
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    router.go('/home');
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: links
                .map((e) => TextButton(
                      onPressed: () => {
                        e.onPressed(),
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromRGBO(1, 1, 1, 0)),
                      ),
                      child: Text(
                        e.text,
                        style: GoogleFonts.raleway(
                            decoration: TextDecoration.overline,
                            decorationColor:
                                const Color.fromRGBO(255, 81, 81, 1),
                            decorationThickness: 3.0,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ))
                .toList(),
          ),
          const Padding(padding: EdgeInsets.all(4))
        ],
      ),
    );
  }
}

class LinkModel {
  final String text;
  final Function onPressed;

  LinkModel({required this.text, required this.onPressed});
}
