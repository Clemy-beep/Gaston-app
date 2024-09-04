import 'dart:convert';

import 'package:app/services/model-services/commentary_model_service.dart';

class StepModelservice {
  String? _stepDescription;
  String? _timer;
  String? _stepName;
  int? _stepNumber;
  List<CommentaryModelService>? _commentaries = [];
  int? _reportsNumber;
  int? _stepCategory;

  StepModelservice({
    String? stepDescription,
    String? timer,
    String? stepName,
    int? stepNumber,
    List<CommentaryModelService>? commentaries,
    int? reportsNumber,
    int? stepCategory,
  }) {
    _stepDescription = stepDescription;
    _timer = timer;
    _stepName = stepName;
    _stepNumber = stepNumber;
    _commentaries = commentaries;
    _reportsNumber = reportsNumber;
    _stepCategory = stepCategory;
  }

  String? get stepDescription => _stepDescription;
  String? get timer => _timer;
  String? get stepName => _stepName;
  int? get stepNumber => _stepNumber;
  get commentary => _commentaries;
  get reportsNumber => _reportsNumber;
  int? get stepCategory => _stepCategory;

  set stepDescription(String? stepDescription) {
    _stepDescription = stepDescription;
  }

  set timer(String? timer) {
    _timer = timer;
  }

  set stepName(String? stepName) {
    _stepName = stepName;
  }

  set stepNumber(int? stepNumber) {
    _stepNumber = stepNumber;
  }

  set stepCategory(int? stepCategory) {
    _stepCategory = stepCategory;
  }

  StepModelservice.fromJson(Map<String, dynamic> json) {
    _stepDescription =
        utf8.decode(json['description'].runes.toList()).toString();
    _timer = json['timer'].toString();
    _stepName = json['name'];
    _stepNumber = json['position'];
    _commentaries = json['commentaries'] ?? [];
    _reportsNumber = json['reportsNumber'];
    _stepCategory = json['category'];
  }

  Map<String, dynamic> toJson(String? stepDescription, String? timer,
      String? stepName, int? stepNumber, int? stepCategory) {
    return {
      '"description"': '"${stepDescription}"',
      '"timer"': "${timer ?? null}",
      '"name"': '"${stepName ?? 'name'}"',
      '"category"': "$stepCategory",
    };
  }
}
