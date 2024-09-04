import 'dart:convert';
import 'package:app/services/model-services/tag_model_service.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/auth_model_service.dart';

class TagStorageService {
  Future<TagModelService> createTag(
      int colorTag, String nameTag, int idTag) async {
    final response = await http.post(
      Uri.parse('https://gaston-cuisine.fr/tags/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'colorTag': colorTag,
        'nameTag': nameTag,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return TagModelService.fromJson(json);
    } else {
      throw Exception('Failed to create tag');
    }
  }

  Future<TagModelService?> getTag(int idTag) async {
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/tags/$idTag'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TagModelService.fromJson(json);
    } else {
      throw Exception('Failed to load tag');
    }
  }

  Future<List<TagModelService>>? listTag() async {
    final response = await http.get(
      Uri.parse('https://gaston-cuisine.fr/tags'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => TagModelService.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tag');
    }
  }

  Future<TagModelService> updateTag(
      int idTag, int colorTag, String nameTag) async {
    final response = await http.put(
      Uri.parse('https://gaston-cuisine.fr/tags/$idTag'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'colorTag': colorTag,
        'nameTag': nameTag,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TagModelService.fromJson(json);
    } else {
      throw Exception('Failed to update tag');
    }
  }

  Future<void> deleteTag(int idTag) async {
    final response = await http.delete(
      Uri.parse('https://gaston-cuisine.fr/tags/$idTag'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete tag');
    }
  }
}
