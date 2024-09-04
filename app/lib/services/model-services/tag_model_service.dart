import 'dart:convert';

class TagModelService {
  int? _id;
  String? _color_id;
  String? _name;
  bool _isSelect = false;

  TagModelService(
      {int? id, String? color_id, String? name, bool isSelect = false}) {
    _id = id;
    _color_id = color_id;
    _name = name;
    _isSelect = isSelect;
  }

  get idTag => _id;
  get colorTag => _color_id;
  get nameTag => _name;
  bool get isSelect => _isSelect;

  set isSelect(bool value) {
    _isSelect = value;
  }

  TagModelService.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _color_id = json['color_id'];
    _name = utf8.decode(json['name'].runes.toList()).toString();
    _isSelect = false;
  }
}
