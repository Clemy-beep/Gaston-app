import 'package:app/services/model-services/recipe_model_service.dart';

class CommentaryModelService {
  int? _idCommentary;
  String? _comment;
  String? _images;
  Author? _author;

  CommentaryModelService({
    int? idCommentary,
    int? idStepRecipe,
    int? idRecipe,
    String? comment,
    String? images,
    Author? author,
  }) {
    _idCommentary = idCommentary;
    _comment = comment;
    _images = images;
    _author = author;
  }

  get idCommentary => _idCommentary;
  get comment => _comment;
  get images => _images;
  get author => _author;

  CommentaryModelService.fromJson(Map<String, dynamic> json) {
    _idCommentary = json['idCommentary'];
    _comment = json['comment'];
    _images = json['images'];
    _author = json['username'];
  }
}
