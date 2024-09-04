import 'package:app/services/router.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeFinalPage extends StatelessWidget {
  RecipeFinalPage({super.key, required this.id, required this.recipeName});
  final String? id;
  final String? recipeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        backgroundColor: Colors.white,
        title: CustomH2Title(text: '${recipeName}'),
        actions: [
          IconButton(
              onPressed: () => {router.go('/recipe/${id}')},
              icon: Icon(Icons.close))
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: 1,
                  color: Color.fromRGBO(250, 82, 82, 100),
                  backgroundColor: Color.fromRGBO(255, 201, 201, 100),
                ),
                Text(
                  'Terminée !',
                  style: GoogleFonts.raleway(fontSize: 20),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(38),
                  child: Text(
                    'Bravo ! Vous avez terminé la recette ${recipeName}',
                    style: GoogleFonts.raleway(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset('assets/images/party.gif', height: 200, width: 200),
                const SizedBox(height: 16),
                Text('L\'avez vous aimée ?',
                    style: GoogleFonts.raleway(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        iconSize: 32,
                        splashColor: Color.fromRGBO(4, 173, 122, 20),
                        color: Color.fromRGBO(4, 173, 122, 100)),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.thumb_down_alt_outlined),
                      iconSize: 30,
                      color: Color.fromRGBO(250, 72, 72, 100),
                      splashColor: Color.fromRGBO(250, 72, 72, 20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
