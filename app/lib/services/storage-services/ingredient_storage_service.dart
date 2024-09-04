import 'package:app/services/model-services/ingredient_model_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/auth_model_service.dart';

class IngredientStorageService {
  Future<IngredientModelService> createIngredient(String ingredientName) async {
    final response = await http.post(
      Uri.parse('ingredients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredientName': ingredientName,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return IngredientModelService.fromJson(json);
    } else {
      throw Exception('Failed to create ingredient');
    }
  }

  Future<IngredientModelService?> getIngredient(int idIngredient) async {
    final response = await http.get(
      Uri.parse('ingredients/$idIngredient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return IngredientModelService.fromJson(json);
    } else {
      throw Exception('Failed to load ingredient');
    }
  }

  Future<IngredientModelService> updateIngredient(
      int idIngredient, String ingredientName) async {
    final response = await http.put(
      Uri.parse('/api/ingredients/$idIngredient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredientName': ingredientName,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return IngredientModelService.fromJson(json);
    } else {
      throw Exception('Failed to update ingredient');
    }
  }

  Future<void> deleteIngredient(int idIngredient) async {
    final response = await http.delete(
      Uri.parse('/api/ingredients/$idIngredient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete ingredient');
    }
  }
}
