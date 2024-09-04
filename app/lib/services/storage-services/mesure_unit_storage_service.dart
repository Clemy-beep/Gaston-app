import 'dart:convert';
import 'package:app/services/model-services/mesure_unit_model_service.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/model-services/auth_model_service.dart';

class MesureUnitStorageService {
  Future<MesureUnitModelService> createMesureUnit(String unitName) async {
    final response = await http.post(
      Uri.parse('mesure-units'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'unitName': unitName,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return MesureUnitModelService.fromJson(json);
    } else {
      throw Exception('Failed to create mesure unit');
    }
  }

  Future<MesureUnitModelService?> getMesureUnit(int idMesure) async {
    final response = await http.get(
      Uri.parse('mesure-units/$idMesure'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MesureUnitModelService.fromJson(json);
    } else {
      throw Exception('Failed to load mesure unit');
    }
  }

  Future<MesureUnitModelService> updateMesureUnit(
      int idMesure, String unitName) async {
    final response = await http.put(
      Uri.parse('mesure-units/$idMesure'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'unitName': unitName,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MesureUnitModelService.fromJson(json);
    } else {
      throw Exception('Failed to update mesure unit');
    }
  }

  void deleteMesureUnit(int idMesure) async {
    final response = await http.delete(
      Uri.parse('mesure-units/$idMesure'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthModelService().getToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete mesure unit');
    }
  }
}
