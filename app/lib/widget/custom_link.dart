import 'package:app/services/router.dart';
import 'package:flutter/material.dart';

class CustomLink extends StatelessWidget {
  const CustomLink({super.key, required this.text, required this.url});
  final String text;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => {
              router.go(url),
            },
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all<Color>(
                const Color.fromRGBO(255, 201, 201, 0.25))),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w200,
              color: Color.fromRGBO(255, 81, 81, 1)),
        ));
  }
}
