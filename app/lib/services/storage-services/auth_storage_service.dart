import 'dart:convert';

import 'package:app/main.dart';
import 'package:app/services/model-services/auth_model_service.dart';
import 'package:app/services/router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();

class AuthStorageService {
  Future<void> login(String? login, String? password) async {
    if (login == null || password == null) {
      throw Exception('Login or password is null');
    }
    final response =
        await http.post(Uri.parse('https://gaston-cuisine.fr/auth/login'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "identifier": login,
              "password": password,
            }));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      await getIt<AuthModelService>().setToken(json['token']);
      router.go('/home');
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  String? getToken() {
    // Get token from storage
    return getIt<AuthModelService>().getToken();
  }

  Future<String?> getTokenFromStorage() async {
    // Get token from storage
    return await getIt<AuthModelService>().getTokenFromStorage();
  }

  void logout() async {
    // Remove token from storage
    await getIt<AuthModelService>().logout();
    router.go('/');
  }
}
