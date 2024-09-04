import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthModelService {
  final storage = const FlutterSecureStorage();
  String? _token;

  setToken(String? token) async {
    print("AuthModelService : set token");
    _token = token;
    storage.write(key: "token", value: token);
  }

  String? getToken() {
    return _token;
  }

  Future<String?> getTokenFromStorage() async {
    String? token = await storage.read(key: "token");
    _token = token;
    return token;
  }

  Future<void> logout() async {
    _token = null;
    await storage.delete(key: "token");
  }
}
