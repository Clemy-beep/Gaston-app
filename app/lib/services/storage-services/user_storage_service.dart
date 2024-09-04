import 'dart:convert';
import 'package:app/main.dart';
import 'package:app/services/model-services/recipe_model_service.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import "../model-services/user_model_service.dart";

class UserStorageService {
// POST data
  Future<void> createUser(String? firstname, String? lastname, String? email,
      String? username, String? biography, String? password) async {
    final response = await http.post(
      Uri.parse('https://gaston-cuisine.fr/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'biography': biography ?? 'ajoutez une biographie',
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
    router.go('/login');
  }

  void updateUser(
    int idUser,
    String firstname,
    String lastname,
    String email,
    String biography,
    String username,
  ) async {
    final String? token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('https://gaston-cuisine.fr/users/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'biography': biography,
        'username': username,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to update user');
    }
  }

  void deleteUser(int idUser) async {
    final String? token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('https://gaston-cuisine.fr/users/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('peux pas le supprimer ');
    }
  }

  Future<UserModelService> getUser(int idUser) async {
    final String? token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/users/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModelService.fromJson(json);
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<List<UserModelService>> getUsers() async {
    final String? token = await getIt<AuthStorageService>().getToken();
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/users/all'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => UserModelService.fromJson(e)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to get users');
    }
  }

  Future<UserModelService> getMe() async {
    final String? token = getIt<AuthStorageService>().getToken();
    print(token);
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/users/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModelService.fromJson(json);
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to get me ${response.body}');
    }
  }

  Future<Author> getRecipeAuthor(int idUser) async {
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/users/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${getIt<AuthStorageService>().getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = UserModelService.fromJson(json);
      return Author.fromJson(user);
    } else {
      throw Exception('Failed to get user');
    }
  }
}
