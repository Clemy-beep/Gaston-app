import 'package:app/services/model-services/recipe_model_service.dart';
import 'package:app/widget/recipe_card.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key, required this.recipes});
  final List<RecipeModelService> recipes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return RecipeCard(
            id: recipes[index].idRecipe ?? 0,
            imgSrc: recipes[index].image ?? "",
            title: recipes[index].name ?? "",
            comments: recipes[index].commentaries?.length ?? 0,
            likes: recipes[index].likes ?? 0,
          );
        },
      ),
    );
  }
}
