import 'dart:async';

import 'package:app/services/model-services/auth_model_service.dart';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:app/services/storage-services/fruit_storage_service.dart';
import 'package:app/services/storage-services/recipies_storage_service.dart';
import 'package:app/services/storage-services/tag_storage_service.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widget/custom_subtitle.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'services/router.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_title.dart';
import 'package:google_fonts/google_fonts.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AuthModelService>(AuthModelService());
  getIt.registerSingleton<AuthStorageService>(AuthStorageService());

  getIt.registerSingleton<UserStorageService>(UserStorageService());
  getIt.registerSingleton<UserInfoService>(UserInfoService());

  getIt.registerSingleton<RecipiesStorageService>(RecipiesStorageService());
  getIt.registerSingleton<TagStorageService>(TagStorageService());
  getIt.registerSingleton<FruitStorageService>(FruitStorageService());
}

void main() {
  
  print(" im a whale :3");
  //whale animal ascii art
  print('''

      __________...----..____..-'``-..___
    ,'.                                  ```--.._
   :                                             ``._
   |                           --                    ``.
   |                   -.-         -.     -   -.        `.
   :                     __           --            .     \\
    `._____________     (  `.   -.-      --  -   .   `     \\
       `-----------------\\   \\_.--------..__..--.._ `. `.   :
                          `--'     SSt             `-._ .   |
                                                       `.`  |
                                                         \\` |
                                                          \\ |
                                                          / \\`.
                                                         /  _\\-'
                                                        /_,' 
                                                        ''');
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.raleway().fontFamily,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<AuthStorageService>().getTokenFromStorage(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error, ${snapshot.error.toString()}'),
              ),
            );
          }
          if (snapshot.hasData) {
            Future.delayed(const Duration(milliseconds: 0), () {
              router.go('/home');
            });
          }
          return DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            position: DecorationPosition.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CustomH1Title(text: 'Gaston'),
                      const Padding(padding: EdgeInsets.all(16)),
                      Image.asset(
                        'assets/images/gastonLogo.png',
                        height: 290,
                        width: 350,
                        fit: BoxFit.contain,
                      ),
                      const Padding(padding: EdgeInsets.all(16)),
                      const CustomSubtitle(text: 'Votre chef à la maison !'),
                      const Padding(padding: EdgeInsets.all(16)),
                      CustomMainActionButton(
                        onPressed: () {
                          router.go('/login');
                        },
                        text: 'Connexion',
                        icon: Icons.login,
                      ),
                      const Padding(padding: EdgeInsets.all(16)),
                      CustomTextButton(
                          text: 'S\'iinscrire',
                          onPressed: () => {router.go('/sign-up')})
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
