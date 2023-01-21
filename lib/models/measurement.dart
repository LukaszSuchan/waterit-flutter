import 'dart:convert';
import 'dart:ffi';

List<Measurement> measurementFromJson(String str) {
  print(str);
  final jsonData = json.decode(str);
  return List<Measurement>.from(jsonData.map((x) => Measurement.fromJson(x)));
}

class Measurement {
  late double temperature;
  late double humidity;
  late double lightIntensity;
  late double moistureHumidity;
  late DateTime createdAt;

  // constructor
  Measurement(
      {
      required this.temperature,
      required this.humidity,
      required this.lightIntensity,
      required this.moistureHumidity,
      required this.createdAt}) {}

  // create the Measurement object from json input
  Measurement.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    humidity = json['humidity'];
    lightIntensity = json['lightIntensity'];
    moistureHumidity = json['moistureHumidity'];
    createdAt = DateTime.parse(json['dateOfMeasurement']);
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temperature'] = temperature;
    data['humidity'] = humidity;
    data['createdAt'] = createdAt;
    return data;
  }
}
