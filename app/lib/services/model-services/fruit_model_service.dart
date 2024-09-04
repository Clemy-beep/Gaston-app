class FruitModelService {
  String? _name;
  int? _id;
  String? _family;
  String? _order;
  String? _genus;
  Nutritions? _nutritions;

  fruitModelService(
      {String? name,
      int? id,
      String? family,
      String? order,
      String? genus,
      Nutritions? nutritions}) {
    _name = name;
    _id = id;
    _family = family;
    _order = order;
    _genus = genus;
    _nutritions = nutritions;
  }

  FruitModelService.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _id = json['id'];
    _family = json['family'];
    _order = json['order'];
    _genus = json['genus'];
    _nutritions = Nutritions(
        carbohydrates: json['nutritions']['carbohydrates'],
        protein: json['nutritions']['protein'],
        fat: json['nutritions']['fat'],
        calories: json['nutritions']['calories'],
        sugar: json['nutritions']['sugar']);
  }

  get name => _name;
  get id => _id;
  get family => _family;
  get order => _order;
  get genus => _genus;
  get nutritions => _nutritions;
}

class Nutritions {
  double? carbohydrates;
  double? protein;
  double? fat;
  int? calories;
  double? sugar;

  Nutritions(
      {this.carbohydrates, this.protein, this.fat, this.calories, this.sugar});
}
