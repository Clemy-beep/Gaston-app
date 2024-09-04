import 'dart:convert';

import 'package:app/services/router.dart';
import 'package:app/widget/custom_app_bar.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeGroceriesPage extends StatelessWidget {
  const RecipeGroceriesPage(
      {super.key,
      required this.id,
      required this.data,
      required this.imagePath});
  final String id;
  final Object data;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    List<String> groceriesList = jsonEncode(data).split(',');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 1000),
        child: CustomAppBar(text: 'Ingrédients', links: [
          LinkModel(
              text: 'Recette',
              onPressed: () {
                router.go('/recipe/$id');
              }),
          LinkModel(text: 'Ingrédients', onPressed: () {}),
          LinkModel(text: 'Commentaires', onPressed: () {}),
        ]),
      ),
      body: Center(
        child: SizedBox(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(124.0),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                ),
              ),
              CustomH2Title(text: 'Vous aurez besoin de:'),
              Divider(
                color: Color.fromRGBO(250, 82, 82, 100),
                thickness: 4,
                indent: 100,
                endIndent: 100,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              ...groceriesList.map((e) => Padding(
                    padding: const EdgeInsets.only(left: 82.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Color.fromRGBO(250, 82, 82, 100),
                          weight: 100,
                        ),
                        Text(
                          e.replaceAll('"', ''),
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ))
            ],
          )),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
