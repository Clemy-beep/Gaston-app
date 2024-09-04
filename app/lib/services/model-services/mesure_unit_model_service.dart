class MesureUnitModelService {
  int? _idMesure;
  String? _unitName;

  mesureUnitModelService({int? idMesure, String? unitName}) {
    _idMesure = idMesure;
    _unitName = unitName;
  }

  get idMesure => _idMesure;
  get unitName => _unitName;

  MesureUnitModelService.fromJson(Map<String, dynamic> json) {
    _idMesure = json['idMesure'];
    _unitName = json['unitName'];
  }
}
