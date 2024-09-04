import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model-services/fruit_model_service.dart';

class FruitStorageService {
  Future<List<FruitModelService>> fetchFruits() async {
    final response = await http.get(
        Uri.parse('https://www.fruityvice.com/api/fruit/all'),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      return body.map((e) => FruitModelService.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch fruits');
    }
  }

  Future<void> addFruit(FruitModelService fruit) async {
    // Add fruit to storage
  }
  Future<void> removeFruit(FruitModelService fruit) async {
    // Remove fruit from storage
  }
  Future<void> updateFruit(FruitModelService fruit) async {
    // Update fruit in storage
  }
}
