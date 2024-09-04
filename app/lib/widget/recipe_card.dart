import 'package:app/services/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard(
      {super.key,
      required this.id,
      required this.imgSrc,
      required this.title,
      required this.comments,
      required this.likes});
  final String imgSrc;
  final String title;
  final int comments;
  final int likes;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 140,
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(86.0),
          child: Image.network(
            imgSrc,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        InkWell(
          onTap: () {
            router.go('/recipe/$id');
          },
          child: Text(
            title,
            style: GoogleFonts.raleway(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 4,
                decorationColor: const Color.fromRGBO(255, 150, 151, 1)),
          ),
        ),
        const Padding(padding: EdgeInsets.all(2.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mode_comment_outlined,
                  color: Color.fromRGBO(255, 81, 81, 1),
                  weight: 100,
                ),
                const Padding(padding: EdgeInsets.only(left: 4.0)),
                Text(
                  comments.toString(),
                  style: GoogleFonts.raleway(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  likes >= 0
                      ? Icons.favorite_border
                      : Icons.heart_broken_outlined,
                  color: likes >= 0
                      ? const Color.fromRGBO(255, 184, 0, 1)
                      : Colors.black,
                ),
                const Padding(padding: EdgeInsets.only(left: 4.0)),
                Text(
                  likes.toString(),
                  style: GoogleFonts.raleway(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color.fromRGBO(255, 201, 201, 1)),
                )
              ],
            ),
          ],
        )
      ]),
    );
  }
}
