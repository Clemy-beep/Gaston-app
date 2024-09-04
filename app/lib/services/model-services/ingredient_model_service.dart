class IngredientModelService {
  int? _idIngredient;
  String? _ingredientName;

  IngredientModelService({int? idIngredient, String? ingredientName}) {
    _idIngredient = idIngredient;
  }

  get idIngredient => _idIngredient;
  get ingredientname => _ingredientName;
  IngredientModelService.fromJson(Map<String, dynamic> json) {
    _idIngredient = json['idIngredient'];
    _ingredientName = json['ingredientName'];
  }
}
