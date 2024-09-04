import 'dart:convert';
import 'package:app/services/model-services/auth_model_service.dart';
import 'package:http/http.dart' as http;

class UserInfo {
  final String firstname;
  final String lastname;
  final String biography;
  final List<String> roles;
  final String createdAt;
  final int id;
  final String email;
  final int reporting;
  // final String password;
  final String username;
  final String? token;
  final String images;

  UserInfo({
    required this.firstname,
    required this.lastname,
    required this.biography,
    required this.roles,
    required this.createdAt,
    required this.id,
    required this.email,
    required this.reporting,
    required this.username,
    required this.token,
    required this.images,
  }) {}

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      firstname: json['firstname'],
      lastname: json['lastname'],
      biography: json['biography'],
      roles: List<String>.from(json['roles']),
      createdAt: json['createdAt'],
      id: json['id'],
      email: json['email'],
      reporting: json['reporting'],
      username: json['username'],
      token: json['token'],
      images: json['images'],
    );
  }
}

class UserInfoService {
  UserInfo? _me;
  final Map<int, UserInfo> _usersInfo = {};

  Future<UserInfo> updateMe() async {
    final response = await http
        .get(Uri.parse('https://gaston-cuisine.fr/users/me'), headers: {
      "Content-Type": "application",
      'Authorization': 'Bearer ${AuthModelService().getToken()}',
    }).onError((error, stackTrace) {
      print([error, stackTrace]);
      throw Exception('Failed to fetch user info');
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      UserInfo me = UserInfo.fromJson(body);
      _me = me;
      _usersInfo[me.id] = me;
      return me;
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  UserInfo? getMe() {
    return _me;
  }

  Future<UserInfo> getFromNetwork(int id) async {
    final response = await http
        .get(Uri.parse('https://gaston-cuisine.fr/users/$id'), headers: {
      "Content-Type": "application",
      'Authorization': 'Bearer ${AuthModelService().getToken()}'
    }).onError((error, stackTrace) {
      print([error, stackTrace]);
      throw Exception('Failed to fetch user info');
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      UserInfo user = UserInfo.fromJson(body);
      _usersInfo[user.id] = user;
      return user;
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<UserInfo?> getUserInfo(int id) async {
    if (_usersInfo.containsKey(id)) {
      return _usersInfo[id];
    } else {
      return getFromNetwork(id).catchError((error) {
        print('ERR : $error');
        throw Exception('Failed to fetch user info');
      });
    }
  }
}
