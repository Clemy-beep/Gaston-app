import 'dart:convert';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import '../model-services/step_model_service.dart';
import 'package:app/services/model-services/auth_model_service.dart';

class StepStorageService {
  // create Step Recipies
  Future<StepModelservice?> createStepRecipe(
    int idRecipe,
    List<StepModelservice> steps,
  ) async {
    final response = await http.post(
      Uri.parse('https://gaston-cuisine.fr/recipes/$idRecipe/steps'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode({steps}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return StepModelservice.fromJson(json);
    } else {
      throw Exception('Failed to create vote');
    }
  }

  Future<StepModelservice?> updateStepRecipe(
    int idRecipe,
    int stepNumber,
    String? stepDescription,
    String? timer,
    String? stepName,
    String? stepCategory,
  ) async {
    final response = await http.put(
      Uri.parse(
          'https://gaston-cuisine.fr/recipes/$idRecipe/steps/$stepNumber'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'stepDescription': stepDescription,
        'timer': timer,
        'stepName': stepName,
        'stepCategory': stepCategory
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return StepModelservice.fromJson(json);
    } else {
      throw Exception('Failed to create vote');
    }
  }

  void deleteStepRecipe(int idRecipe, int stepNumber) async {
    final response = await http.delete(
        Uri.parse('/recipes/$idRecipe/steps/$stepNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthModelService().getToken()}',
        });
    if (response.statusCode != 204) {
      throw Exception('Failed to delete step');
    }
  }

// fetch data from api
  Future<List<StepModelservice>> getStepRecipe(
    int idRecipe,
  ) async {
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/recipes/$idRecipe/steps'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthStorageService().getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json as List).map((e) => StepModelservice.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load steps');
    }
  }
}
