import 'dart:convert';
import 'package:app/main.dart';
import 'package:app/services/model-services/step_model_service.dart';
import 'package:app/services/model-services/tag_model_service.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:http/http.dart' as http;
import '../model-services/recipe_model_service.dart';
import 'package:app/services/model-services/auth_model_service.dart';

class RecipiesStorageService {
  Future<Iterable<RecipeModelService>> fetchRecipes() async {
    final response =
        await http.post(Uri.parse('https://gaston-cuisine.fr/recipes/search'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${AuthStorageService().getToken()}'
            },
            body: jsonEncode({}));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final recipes = <RecipeModelService>[];
      for (var recipe in json) {
        if (recipe['images'].length > 0) {
          if (recipe['images'][0] != 'string') {
            bool doesImageExist = await validateRecipeImage(
                'https://gaston-cuisine.fr/images/${recipe['images'][0]}');
            if (doesImageExist) {
              recipe['images'] =
                  'https://gaston-cuisine.fr/images/${recipe['images'][0]}';
            } else {
              recipe['images'] =
                  'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
            }
          } else {
            recipe['images'] =
                'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
          }
        } else {
          recipe['images'] =
              'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
        }
        recipe['author'] = await getIt<UserStorageService>()
            .getRecipeAuthor(recipe['id_user']);
        recipe['steps'] = recipe['steps']
            .map((e) => StepModelservice.fromJson(e))
            .toList()
            .cast<StepModelservice>();
        recipes.add(RecipeModelService.fromJson(recipe));
      }
      return recipes.reversed.take(10);
    }
    throw Exception('Failed to load recipes');
  }

  Future<bool> createRecipe(
      String? name,
      String? description,
      String? difficulty,
      String? estimatedTime,
      String? imagePath,
      List<StepModelservice>? steps,
      List? tags) async {
    var tagsApi = {'ids': tags};
    var stepsApi = steps!
        .map((e) => e.toJson(e.stepDescription, e.timer, e.stepName,
            e.stepNumber, e.stepCategory))
        .toList();

    print(imagePath);
    var req = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://gaston-cuisine.fr/recipes/',
        ));
    var token = AuthStorageService().getToken();
    req.headers['Authorization'] = 'Bearer $token';
    if (imagePath != null) {
      req.files.add(await http.MultipartFile.fromPath(
        'file',
        imagePath,
      ));
      req.fields['recipe'] =
          '{"name": "$name", "description": "$description", "difficulty": $difficulty, "estimated_time": "$estimatedTime", "stepRecipe": $stepsApi, "tags": ${jsonEncode(tagsApi)}, "images": ["string"]}';
    } else {
      req.fields['recipe'] =
          '{"name": "$name", "description": "$description", "difficulty": $difficulty, "estimated_time": "$estimatedTime", "stepRecipe": $stepsApi, "tags": ${jsonEncode(tagsApi)}}';
    }
    var response = await req.send().catchError((error) {
      print(error);
      throw Exception('Failed to create recipe');
    });
    if (response.statusCode == 201) {
      router.go('/home');
      return true;
    }
    throw Exception('Failed to create recipe');
  }

  Future<RecipeModelService?> updateRecipies(
    String idRecipe,
    String name,
    String description,
    int difficulty,
    String estimatedTime,
    int price,
    String images,
    int reportNumber,
    List steps,
    List tags,
    String ingredient,
  ) async {
    final response = await http.put(
      Uri.parse('/api/recipies?recipies=$idRecipe'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getTokenFromStorage()}',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "description": description,
        "difficulty": difficulty,
        "estimatedTime": estimatedTime,
        "price": price,
        "images": images,
        "steps": steps,
        "tags": tags,
        // ingredient is a string for now until new order
        "ingredient": ingredient
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RecipeModelService.fromJson(json);
    } else {
      throw Exception('Failed to create vote');
    }
  }

  void deleteRecipies(
    String idRecipe,
  ) async {
    final response = await http.delete(
        Uri.parse('https://gaston-cuisine.fr/recipes/$idRecipe'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthStorageService().getToken()}',
        });
    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipies');
    }
  }

  // fetch data from api there is recipies and steprecipies
  Future<RecipeModelService?> getRecipe(
    int idRecipe,
  ) async {
    print(idRecipe);
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/recipes/$idRecipe'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthStorageService().getToken()}',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body);
      print(json['images'].length);
      bool isGreatereThan = json['images'].length > 0;
      print(isGreatereThan);
      if (json['images'].length > 0) {
        if (json['images'][0] != 'string') {
          bool doesImageExist = await validateRecipeImage(
              'https://gaston-cuisine.fr/images/${json['images'][0]}');
          if (doesImageExist) {
            json['images'] =
                'https://gaston-cuisine.fr/images/${json['images'][0]}';
          } else {
            json['images'] =
                'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
          }
        }
      } else {
        json['images'] =
            'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
      }
      json['author'] =
          await getIt<UserStorageService>().getRecipeAuthor(json['id_user']);

      print(json);
      json['steps'] = json['steps']
          .map((e) => StepModelservice.fromJson(e))
          .toList()
          .cast<StepModelservice>();
      json['tags'] = json['tags']
          .map((e) => TagModelService.fromJson(e))
          .toList()
          .cast<TagModelService>();
      return RecipeModelService.fromJson(json);
    } else {
      if (response.statusCode == 404) {
        return null;
      }
      if (response.statusCode == 401) {
        AuthStorageService().logout();
      }
      if (response.statusCode == 403) {
        AuthStorageService().logout();
      }
      print(response.statusCode);
      throw Exception('Failed to load step');
    }
  }

  Future<bool> validateRecipeImage(String uri) {
    return http.get(Uri.parse(uri)).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<List<RecipeModelService>> getUserRecipes(int userId) async {
    final response =
        await http.post(Uri.parse('https://gaston-cuisine.fr/recipes/search'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${AuthStorageService().getToken()}'
            },
            body: jsonEncode({'author': userId}));
    if (response.statusCode != 200) {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load user recipes');
    }
    final json = jsonDecode(response.body);
    final recipes = <RecipeModelService>[];
    for (var recipe in json) {
      if (recipe['images'].length > 0) {
        if (recipe['images'][0] != 'string') {
          bool doesImageExist = await validateRecipeImage(
              'https://gaston-cuisine.fr/images/${recipe['images'][0]}');
          if (doesImageExist) {
            recipe['images'] =
                'https://gaston-cuisine.fr/images/${recipe['images'][0]}';
          } else {
            recipe['images'] =
                'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
          }
        } else {
          recipe['images'] =
              'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
        }
      } else {
        recipe['images'] =
            'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';
      }
      recipe['author'] =
          await getIt<UserStorageService>().getRecipeAuthor(recipe['id_user']);
      recipe['steps'] = recipe['steps']
          .map((e) => StepModelservice.fromJson(e))
          .toList()
          .cast<StepModelservice>();
      recipes.add(RecipeModelService.fromJson(recipe));
    }
    return recipes;
  }
}
