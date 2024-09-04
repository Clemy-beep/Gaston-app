import 'package:app/services/model-services/recipe_ingredient_quantity_model_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/auth_model_service.dart';

class RecipiesIngredientQuantityStorageService {
  Future<RecipeIngredientQuantityModelService> createRecipeIngredientQuantity(
      int recipeId, List ingredient, List mesure, int quantity) async {
    final response = await http.post(
      Uri.parse('/api/recipes/$recipeId/ingredients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredientId': ingredient,
        'mesureId': mesure,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return RecipeIngredientQuantityModelService.fromJson(json);
    } else {
      throw Exception('Failed to create recipe ingredient quantity');
    }
  }

  Future<RecipeIngredientQuantityModelService> updateRecipeIngredientQuantity(
      int recipeId, int ingredientId, List mesure, int quantity) async {
    final response = await http.put(
      Uri.parse('/api/recipes/$recipeId/ingredients/$ingredientId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'mesureId': mesure,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RecipeIngredientQuantityModelService.fromJson(json);
    } else {
      throw Exception('Failed to update recipe ingredient quantity');
    }
  }

  Future<void> deleteRecipeIngredientQuantity(
      int recipeId, int ingredientId) async {
    final response = await http.delete(
      Uri.parse('/api/recipes/$recipeId/ingredients/$ingredientId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipe ingredient quantity');
    }
  }

  Future<List<RecipeIngredientQuantityModelService>>
      getRecipeIngredientQuantities(int recipeId) async {
    final response = await http.get(
      Uri.parse('/api/recipes/$recipeId/ingredients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      final List<RecipeIngredientQuantityModelService>
          recipeIngredientQuantities = data
              .map(
                  (item) => RecipeIngredientQuantityModelService.fromJson(item))
              .toList();
      return recipeIngredientQuantities;
    } else {
      throw Exception('Failed to load recipe ingredient quantities');
    }
  }
}
