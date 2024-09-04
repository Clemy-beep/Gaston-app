import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/commentary_model_service.dart';
import 'package:app/services/model-services/auth_model_service.dart';

class CommentaryStorageService {
  Future<CommentaryModelService> createCommentary(
      String comment, String images, String username) async {
    final response = await http.post(
      Uri.parse('/api/commentaries'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'comment': comment,
        'images': images,
        'username': username,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return CommentaryModelService.fromJson(json);
    } else {
      throw Exception('Failed to create commentary');
    }
  }

  Future<CommentaryModelService?> getCommentary(int idCommentary) async {
    final response = await http.get(
      Uri.parse('/api/commentaries/$idCommentary'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CommentaryModelService.fromJson(json);
    } else {
      throw Exception('Failed to load commentary');
    }
  }

  Future<CommentaryModelService> updateCommentary(
      int idCommentary, String comment, String images, String username) async {
    final response = await http.put(
      Uri.parse('/api/commentaries/$idCommentary'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'comment': comment,
        'images': images,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CommentaryModelService.fromJson(json);
    } else {
      throw Exception('Failed to update commentary');
    }
  }

  void deleteCommentary(int idCommentary) async {
    final response = await http.delete(
      Uri.parse('/api/commentaries/$idCommentary'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete commentary');
    }
  }
}
