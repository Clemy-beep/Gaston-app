import 'package:app/services/model-services/commentary_model_service.dart';
import 'package:app/services/model-services/recipe_model_service.dart';
import 'package:app/services/router.dart';
import 'package:app/widget/add_recipe_floating_action_button.dart';
import 'package:app/widget/carousel.dart';
import 'package:app/widget/comment_floating_action_button.dart';
import 'package:app/widget/custom_app_bar.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_dropdown_menu.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:app/widget/custom_link.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_subtitle.dart';
import 'package:app/widget/custom_tag.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:app/widget/custom_text_input.dart';
import 'package:app/widget/custom_title.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownItem> myItems = [
    DropdownItem(1, 'Item 1'),
    DropdownItem(2, 'Item 2'),
    DropdownItem(3, 'Item 3'),
  ];

  List<LinkModel> links = [
    LinkModel(text: 'Home', onPressed: () => {router.go('/')}),
    LinkModel(text: 'Profile', onPressed: () => {}),
    LinkModel(text: 'Settings', onPressed: () => {}),
  ];

  List<RecipeModelService> recipes = [
    RecipeModelService(
      idRecipe: 1,
      name: 'chili con carne',
      image:
          'https://media.istockphoto.com/id/486539406/fr/photo/bio-maison-chilli-v%C3%A9g%C3%A9tarien.jpg?s=612x612&w=0&k=20&c=pCVDMBSwwOK-YeB4RzDHt-i6Hm_2AAJyxlnnZUkayz8=',
      commentaries: [
        CommentaryModelService(
          idCommentary: 1,
          author: Author(username: 'SuperChef', idUser: 1),
          comment: 'Super recette',
        ),
        CommentaryModelService(
          idCommentary: 2,
          author: Author(idUser: 2, username: 'SuperChef2'),
          comment: 'Super recette 2',
        )
      ],
      likes: -18,
    ),
    RecipeModelService(
      idRecipe: 4,
      name: 'chili con carne',
      image:
          'https://media.istockphoto.com/id/486539406/fr/photo/bio-maison-chilli-v%C3%A9g%C3%A9tarien.jpg?s=612x612&w=0&k=20&c=pCVDMBSwwOK-YeB4RzDHt-i6Hm_2AAJyxlnnZUkayz8=',
      commentaries: [
        CommentaryModelService(
          idCommentary: 1,
          author: Author(username: 'SuperChef', idUser: 1),
          comment: 'Super recette',
        ),
        CommentaryModelService(
          idCommentary: 2,
          author: Author(idUser: 2, username: 'SuperChef2'),
          comment: 'Super recette 2',
        )
      ],
      likes: 18,
    ),
    RecipeModelService(
      idRecipe: 2,
      name: 'chili con carne',
      image:
          'https://media.istockphoto.com/id/486539406/fr/photo/bio-maison-chilli-v%C3%A9g%C3%A9tarien.jpg?s=612x612&w=0&k=20&c=pCVDMBSwwOK-YeB4RzDHt-i6Hm_2AAJyxlnnZUkayz8=',
      commentaries: [
        CommentaryModelService(
          idCommentary: 1,
          author: Author(username: 'SuperChef', idUser: 1),
          comment: 'Super recette',
        ),
        CommentaryModelService(
          idCommentary: 2,
          author: Author(idUser: 2, username: 'SuperChef2'),
          comment: 'Super recette 2',
        )
      ],
      likes: 1,
    ),
    RecipeModelService(
        idRecipe: 3,
        name: 'chili con carne',
        image:
            'https://media.istockphoto.com/id/486539406/fr/photo/bio-maison-chilli-v%C3%A9g%C3%A9tarien.jpg?s=612x612&w=0&k=20&c=pCVDMBSwwOK-YeB4RzDHt-i6Hm_2AAJyxlnnZUkayz8=',
        commentaries: [
          CommentaryModelService(
            idCommentary: 1,
            author: Author(username: 'SuperChef', idUser: 1),
            comment: 'Super recette',
          ),
          CommentaryModelService(
            idCommentary: 2,
            author: Author(idUser: 2, username: 'SuperChef2'),
            comment: 'Super recette 2',
          )
        ],
        likes: 15)
  ];
  @override
  Widget build(BuildContext context) {
    //Future<String?> token = getIt<AuthStorageService>().getToken();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(links: links),
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        // child: Titlecomponentsassetsvisual(text: 'JAPAN EXPOOO'),
        child: SizedBox(
          // height: MediaQuery.of(context).size.,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              const CustomH1Title(text: ' Bienvenue AMexicanGuy'),
              const CustomSubtitle(text: 'Sous-titre'),
              const CustomH2Title(text: 'Exemple de titre H2'),
              CustomTextButton(text: "Suivant", onPressed: () => {}),
              CustomTextInput(
                labelText: 'Nom',
                hintText: 'Entrez votre nom',
                width: 300.0, // Configurer la largeur
                maxlines: 2, // Configurer la hauteur
                onChanged: (value) => '',
              ),
              const CustomLink(text: 'Voir mon profil', url: '/profile/my'),
              CustomDropdownMenu(
                items: myItems,
                hint: 'Choisir un item',
                dropdownValue: myItems[0].key,
                onChanged: (e) => {
                  print(e),
                },
              ),
              const CustomTag(
                text: 'méditéranéenne',
                color: 'FDA4DF',
                isSelect: true,
              ),
              CustomMainActionButton(
                  text: 'Commencer',
                  onPressed: () => {},
                  icon: Icons.not_started_outlined),
              Carousel(recipes: recipes)
            ],
          ),
        ),
      ),
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AddRecipeFloatingActionButton(),
          Padding(padding: EdgeInsets.all(8.0)),
          CommentFloatingActionButton()
        ],
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
