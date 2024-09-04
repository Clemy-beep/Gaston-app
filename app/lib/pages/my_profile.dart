import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/recipies_storage_service.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:app/widget/custom_app_bar.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_title.dart';
import 'package:app/widget/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    int id;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 1000),
        child: FutureBuilder(
            future: getIt<UserStorageService>().getMe(),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError ||
                  snapshot.data == null ||
                  !snapshot.hasData) {
                return Row(
                  children: [
                    Text('Error: ${snapshot.error}'),
                  ],
                );
              }
              //id = snapshot.data!.idUser;
              return CustomAppBar(
                text: 'Votre profil',
                links: [
                  LinkModel(
                      text: 'Votre profil',
                      onPressed: () {
                        router.go(
                            '/user/${snapshot.data!.idUser}?username=${snapshot.data!.username}');
                      }),
                  LinkModel(
                      text: 'Vos infos',
                      onPressed: () {
                        router.go('/user/${snapshot.data!.idUser}/info');
                      })
                ],
              );
            }),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              FutureBuilder(
                  future: getIt<UserStorageService>().getMe(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError ||
                        snapshot.data == null ||
                        !snapshot.hasData) {
                      return ClipRRect(
                          child: Image.network(
                            'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                          borderRadius: BorderRadius.circular(124));
                    }
                    if (snapshot.data!.avatar != null) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(124.0),
                            child: Image.network(
                              snapshot.data!.avatar! == '{}'
                                  ? 'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png'
                                  : snapshot.data!.avatar!,
                              fit: BoxFit.cover,
                              height: 160,
                              width: 160,
                            ),
                          ),
                          Text(
                            '${snapshot.data!.username}',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month_outlined,
                                  size: 16,
                                  weight: 100,
                                  color: Color.fromRGBO(250, 82, 82, 100)),
                              Text(
                                'Inscrit depuis le ${snapshot.data!.createdAt}',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomH1Title(text: 'Vos dernière \n recettes'),
                            ],
                          ),
                          FutureBuilder(
                              future: getIt<RecipiesStorageService>()
                                  .getUserRecipes(snapshot.data!.idUser),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No recipes');
                                }
                                return Wrap(
                                  spacing: 0,
                                  children: snapshot.data!
                                      .map((recipe) => RecipeCard(
                                          id: recipe.idRecipe,
                                          imgSrc: recipe.image ?? '',
                                          title: recipe.name ?? '',
                                          comments:
                                              recipe.commentaries?.length ?? 0,
                                          likes: 0))
                                      .toList(),
                                );
                              })
                        ],
                      );
                    }
                    return ClipRRect(
                        child: Image.network(
                          'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png',
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        ),
                        borderRadius: BorderRadius.circular(124));
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
