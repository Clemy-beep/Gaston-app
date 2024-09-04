import 'dart:convert';

import 'package:app/services/model-services/tag_model_service.dart';
import 'package:app/services/model-services/commentary_model_service.dart';
import 'package:app/services/model-services/recipe_ingredient_quantity_model_service.dart';
import 'package:app/services/model-services/step_model_service.dart';
import 'package:app/services/model-services/user_model_service.dart';

class RecipeModelService {
  int? _idRecipe;
  String? _name;
  String? _description;
  int? _difficulty;
  String? _estimatedTime;
  double? _price;
  String? _image;
  int? _reportNumber;
  List<StepModelservice>? _steps = [];
  List<TagModelService>? _tags = [];
  Author? _author;
  int? _likes = 0;
  List<CommentaryModelService>? _commentaries = [];
  List<RecipeIngredientQuantityModelService>? _recipeIngredients = [];
  List<String>? _ingredients = [];
  String? _createdAt;

  RecipeModelService(
      {int? idRecipe,
      int? idUser,
      String? name,
      String? description,
      int? difficulty,
      String? estimatedTime,
      double? price,
      String? image,
      int? reportNumber,
      List<StepModelservice>? steps,
      List<TagModelService>? tags,
      Author? author,
      int? likes,
      List<CommentaryModelService>? commentaries,

      /*
      * List if we got time else we use String 
      */

      String? createdAt}) {
    _idRecipe = idRecipe;
    _name = name;
    _description = description;
    _difficulty = difficulty;
    _estimatedTime = estimatedTime;
    _price = price;
    _image = image;
    _reportNumber = reportNumber;
    _steps = steps;
    _tags = tags;
    _author = author;
    _likes = likes;
    _commentaries = commentaries;
    _recipeIngredients = recipeIngredients;
    _ingredients = ingredients;
    _createdAt = createdAt;
  }

  int? get idRecipe => _idRecipe;
  String? get name => _name;
  String? get image => _image;
  String? get description => _description;
  int? get report => _reportNumber;
  int? get difficulty => _difficulty;
  String? get estimatedTime => _estimatedTime;
  double? get price => _price;
  List<StepModelservice>? get steps => _steps;
  List<TagModelService>? get tag => _tags;
  Author? get author => _author;
  int? get likes => _likes;
  List<CommentaryModelService>? get commentaries => _commentaries;
  List<RecipeIngredientQuantityModelService>? get recipeIngredients =>
      _recipeIngredients;
  List<String>? get ingredients => _ingredients;
  get createdAt => _createdAt;

  RecipeModelService.fromJson(Map<String, dynamic> json) {
    _idRecipe = json['id'];
    _name = utf8.decode(json['name'].runes.toList()).toString();
    _description = utf8.decode(json['description'].runes.toList()).toString();
    _difficulty = json['difficulty'];
    _estimatedTime = json['estimated_time'].toString();
    _price = json['price'];
    _image = json['images'];
    _reportNumber = json['reportNumber'];
    _steps = json['steps'];
    _tags = json['tags'];
    _author = json['author'];
    _likes = json['score'];
    _commentaries = json['commentary'];
    _recipeIngredients = json['recipiesIngredient'];
    _ingredients = json['ingredients'];
    _createdAt =
        '${DateTime.parse(json['created_at']).day}/${DateTime.parse(json['created_at']).month}/${DateTime.parse(json['created_at']).year}';
  }
}

class Author {
  int? idUser;
  String? username;

  Author({this.idUser, this.username});

  Author.fromJson(UserModelService user) {
    idUser = user.idUser;
    username = user.username;
  }
}
