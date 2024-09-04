import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/recipies_storage_service.dart';
import 'package:app/widget/custom_app_bar.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_link.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_tag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.id});
  final String? id;

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Center(
        child: Text('No recipe found'),
      );
    }
    return FutureBuilder(
      future: getIt<RecipiesStorageService>().getRecipe(int.parse(id!)),
      builder: (context, snapshot) {
        print('recipe page');
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text('No recipe found'),
            ),
            bottomNavigationBar: CustomBottomNavBar(),
          );
        }
        print(snapshot.data);
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 1000),
              child: CustomAppBar(text: snapshot.data!.name!, links: [
                LinkModel(
                    text: 'Recette',
                    onPressed: () {
                      router.go('/recipe/${snapshot.data!.idRecipe}');
                    }),
                LinkModel(
                    text: 'Ingrédients',
                    onPressed: () {
                      router.go(
                          '/recipe/${snapshot.data!.idRecipe}/groceries?imagePath=${snapshot.data!.image}',
                          extra: snapshot.data!.description);
                    }),
                LinkModel(
                    text: 'Etapes',
                    onPressed: () {
                      router.go('/recipe/${snapshot.data!.idRecipe}/steps');
                    }),
                LinkModel(text: 'Commentaires', onPressed: () {}),
              ]),
            ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(124.0),
                          child: Image.network(
                            snapshot.data!.image!,
                            fit: BoxFit.cover,
                            height: 250,
                            width: 250,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.account_circle_outlined,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(padding: EdgeInsets.only(left: 4.0)),
                            Text('Auteur: ',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            CustomLink(
                                text: snapshot.data!.author!.username!,
                                url:
                                    '/user-profile/${snapshot.data!.author!.idUser}?username=${snapshot.data!.author!.username}'),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.calendar_month_outlined,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(padding: EdgeInsets.only(left: 4.0)),
                            Text('Publiée le: ',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text(snapshot.data!.createdAt.toString(),
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.star_border_outlined,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(
                                padding: const EdgeInsets.only(left: 4.0)),
                            Text('Difficulté: ',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text('${snapshot.data!.difficulty}/5',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.scatter_plot_outlined,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(padding: EdgeInsets.only(left: 4.0)),
                            Text('Etapes:',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text(snapshot.data!.steps?.length.toString() ?? '0',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.timer_outlined,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(padding: EdgeInsets.only(left: 4.0)),
                            Text('Temps de préparation:',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text(
                                '${snapshot.data!.estimatedTime.toString()} min',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 64)),
                            const Icon(Icons.tag_rounded,
                                color: Color.fromRGBO(250, 82, 82, 100),
                                weight: 100),
                            const Padding(padding: EdgeInsets.only(left: 4.0)),
                            Text('Tags: ',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Wrap(
                                children: snapshot.data!.tag!
                                    .map((tag) => CustomTag(
                                        text: tag.nameTag.toString(),
                                        color: tag.colorTag.toString(),
                                        isSelect: true))
                                    .toList())
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        CustomMainActionButton(
                            text: 'Démarrer',
                            onPressed: () => {
                                  router.go(
                                      '/recipe/${snapshot.data!.idRecipe}/steps?recipeName=${snapshot.data!.name}')
                                },
                            icon: Icons.play_circle_outline),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavBar());
      },
    );
  }
}
