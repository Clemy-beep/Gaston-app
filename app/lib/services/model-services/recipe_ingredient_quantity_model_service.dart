import 'package:app/services/model-services/ingredient_model_service.dart';
import 'package:app/services/model-services/mesure_unit_model_service.dart';

class RecipeIngredientQuantityModelService {
  IngredientModelService? _ingredient;
  MesureUnitModelService? _mesure;
  int? _quantity;

  recipeIngredientQuantityModelService({
    IngredientModelService? ingredient,
    MesureUnitModelService? mesure,
    int? quantity,
  }) {
    _ingredient = ingredient;
    _mesure = mesure;
    _quantity = quantity;
  }

  get ingredient => _ingredient;
  get mesure => _mesure;
  get quantity => _quantity;

  RecipeIngredientQuantityModelService.fromJson(Map<String, dynamic> json) {
    _ingredient = json['idIngredient'];
    _mesure = json['mesure'];
    _quantity = json['quantity'];
  }
}
