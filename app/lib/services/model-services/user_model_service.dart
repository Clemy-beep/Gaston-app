import 'package:app/services/model-services/recipe_model_service.dart';

class UserModelService {
  int? _idUser;
  String? _firstname;
  String? _lastname;
  String? _email;
  String? _biography;
  String? _username;
  int? _reporting;
  String? _role;
  List<RecipeModelService>? _recipes = [];
  String? _createdAt;
  String? _avatar;

  userService(
      {int? idUser,
      String? firstname,
      String? lastname,
      String? email,
      String? biography,
      String? username,
      int? reporting,
      String? role,
      List<RecipeModelService>? recipes,
      String? avatar,
      String? createdAt}) {
    _idUser = idUser;
    _firstname = firstname;
    _lastname = lastname;
    _email = email;
    _biography = biography;
    _username = username;
    _reporting = reporting;
    _role = role;
    _recipes = recipes;
    _createdAt = createdAt;
    _avatar = avatar;
  }

  get idUser => _idUser;
  get firstname => _firstname;
  get lastname => _lastname;
  get email => _email;
  get biography => _biography;
  get username => _username;
  get report => _reporting;
  get role => _role;
  get recipiesname => _recipes;
  get createdAt => _createdAt;
  get avatar => _avatar;

  @override
  String toString() {
    return 'UserModelService{idUser: $_idUser, firstname: $_firstname, lastname: $_lastname, email: $_email, biography: $_biography, username: $_username, reporting: $_reporting, role: $_role}';
  }

  UserModelService.fromJson(Map<String, dynamic> json) {
    _idUser = json['id'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _email = json['email'];
    _biography = json['biography'];
    _username = json['username'];
    _reporting = json['reporting'];
    _role = json['role'];
    _recipes = json['recipiesname'];
    _createdAt = json['createdAt'];
    _avatar = json['images'];
  }
}
