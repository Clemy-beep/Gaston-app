import 'dart:convert';
import 'package:app/services/model-services/vote_model_service.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/auth_model_service.dart';

/*
* i'm not sure of the logic remind me later to see if it's correct or no 
*/
class Votestoreservice {
// fetch all data
  Future<VoteModelService?> fetchVote(
      VoteModelService vote, String token) async {
    final response = await http.get(
      Uri.parse('/api/votes/${vote.idUser}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return VoteModelService.fromJson(json);
    } else {
      throw Exception('Failed to load vote');
    }
  }

// POST data
  Future<VoteModelService> createVote(
      int idUser, int vote, int idRecipe) async {
    final response = await http.post(
      Uri.parse('/api/votes/$idRecipe'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'idUser': idUser,
        'vote': vote,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return VoteModelService.fromJson(json);
    } else {
      throw Exception('Failed to create vote');
    }
  }

  Future<VoteModelService?> getVote(int idUser) async {
    final response = await http.get(
      Uri.parse('/api/votes/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return VoteModelService.fromJson(json);
    } else {
      throw Exception('Failed to load vote');
    }
  }

// put data manage it
  Future<VoteModelService> updateVote(int idUser, int vote) async {
    final response = await http.put(
      Uri.parse('/api/votes/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'vote': vote,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return VoteModelService.fromJson(json);
    } else {
      throw Exception('Failed to update vote');
    }
  }

// delete (maybe useless for some modelServices)
  Future<void> deleteVote(int idUser) async {
    final response = await http.delete(
      Uri.parse('/api/votes/$idUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete vote');
    }
  }
}
