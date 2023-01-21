import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/prefs.dart';
import 'package:flutter_app/models/measurement.dart';
import 'package:flutter_app/screens/plot/components/background.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final int deviceId;
  const Body({super.key, required this.deviceId});
  @override
  _PlotState createState() => _PlotState();
}

class _PlotState extends State<Body> {
  final List<Color> _humidityGradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];
  final List<Color> _lightIntensityGradientColors = [
    Color.fromARGB(255, 192, 124, 213),
    Color.fromARGB(255, 219, 62, 214),
    Color.fromARGB(255, 63, 0, 252),
  ];
  final List<Color> _temperatureGradientColors = [
    Color.fromARGB(255, 213, 160, 124),
    Color.fromARGB(255, 220, 138, 44),
    Color.fromARGB(255, 252, 55, 0),
  ];
  final List<Color> _moistureHumidityGradientColors = [
    Color.fromARGB(255, 128, 219, 198),
    Color.fromARGB(255, 50, 201, 88),
    Color.fromARGB(255, 34, 252, 0),
  ];
  final int _divider = 25;
  final int _leftLabelsCount = 2;

  List<FlSpot> _humidityValues = const [];
  List<FlSpot> _lightIntensityValues = const [];
  List<FlSpot> _temperatureValues = const [];
  List<FlSpot> _moistureHumidityValues = const [];
  double currentTemperature = 0;
  double currentHumidity = 0;
  double currentLightIntensity = 0;
  double currentMoistureHumidity = 0;

  double _hminX = 0;
  double _hmaxX = 0;
  double _hminY = 0;
  double _hmaxY = 0;
  double _liminX = 0;
  double _limaxX = 0;
  double _liminY = 0;
  double _limaxY = 0;
  double _tminX = 0;
  double _tmaxX = 0;
  double _tminY = 0;
  double _tmaxY = 0;
  double _mhminX = 0;
  double _mhmaxX = 0;
  double _mhminY = 0;
  double _mhmaxY = 0;
  double _hleftTitlesInterval = 0;
  double _lileftTitlesInterval = 0;
  double _tleftTitlesInterval = 0;
  double _mhleftTitlesInterval = 0;
  

  Future<List<Measurement>> fetchMeasurement() async {
    return await getMeasurement(widget.deviceId);
  }

  @override
  void initState() {
    super.initState();
    prepareData();
  }

  void prepareData() async {
    List<Measurement> data = await fetchMeasurement();
    _prepareHumidityData(data);
    _prepareLightIntensityData(data);
    _prepareTemperatureData(data);
    _prepareMoistureHumidityData(data);
  }

  void _prepareHumidityData(List<Measurement> data) async {
    if (data.isEmpty) return;
    currentHumidity = data[data.length - 1].humidity;

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _humidityValues = data.map((datum) {
      if (minY > datum.humidity) minY = datum.humidity.toDouble();
      if (maxY < datum.humidity) maxY = datum.humidity.toDouble();
      return FlSpot(
        datum.createdAt.millisecondsSinceEpoch.toDouble(),
        datum.humidity.toDouble(),
      );
    }).toList();

    _hminX = _humidityValues.first.x;
    _hmaxX = _humidityValues.last.x;
    _hminY = (minY / _divider).floorToDouble() * _divider;
    _hmaxY = (maxY / _divider).ceilToDouble() * _divider;

    _hleftTitlesInterval =
        ((_hmaxY - _hminY) / (_leftLabelsCount - 1)).floorToDouble();

    if (!mounted) return;

    setState(() {});
  }

  void _prepareLightIntensityData(List<Measurement> data) async {
    if (data.isEmpty) return;
    currentLightIntensity = data[data.length - 1].lightIntensity;

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _lightIntensityValues = data.map((datum) {
      if (minY > datum.lightIntensity) minY = datum.lightIntensity.toDouble();
      if (maxY < datum.lightIntensity) maxY = datum.lightIntensity.toDouble();
      return FlSpot(
        datum.createdAt.millisecondsSinceEpoch.toDouble(),
        datum.lightIntensity.toDouble(),
      );
    }).toList();

    _liminX = _lightIntensityValues.first.x;
    _limaxX = _lightIntensityValues.last.x;
    _liminY = (minY / _divider).floorToDouble() * _divider;
    _limaxY = (maxY / _divider).ceilToDouble() * _divider;

    _lileftTitlesInterval =
        ((_limaxY - _liminY) / (_leftLabelsCount - 1)).floorToDouble();

    if (!mounted) return;

    setState(() {});
  }

  void _prepareTemperatureData(List<Measurement> data) async {
    if (data.isEmpty) return;
    currentTemperature = data[data.length - 1].temperature;

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _temperatureValues = data.map((datum) {
      if (minY > datum.temperature) minY = datum.temperature.toDouble();
      if (maxY < datum.temperature) maxY = datum.temperature.toDouble();
      return FlSpot(
        datum.createdAt.millisecondsSinceEpoch.toDouble(),
        datum.temperature.toDouble(),
      );
    }).toList();

    _tminX = _temperatureValues.first.x;
    _tmaxX = _temperatureValues.last.x;
    _tminY = (minY / _divider).floorToDouble() * _divider;
    _tmaxY = (maxY / _divider).ceilToDouble() * _divider;

    _tleftTitlesInterval =
        ((_tmaxY - _tminY) / (_leftLabelsCount - 1)).floorToDouble();

    if (!mounted) return;

    setState(() {});
  }

  void _prepareMoistureHumidityData(List<Measurement> data) async {
    if (data.isEmpty) return;
    currentMoistureHumidity = data[data.length - 1].moistureHumidity;

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _moistureHumidityValues = data.map((datum) {
      if (minY > datum.moistureHumidity) {
        minY = datum.moistureHumidity.toDouble();
      }
      if (maxY < datum.moistureHumidity) {
        maxY = datum.moistureHumidity.toDouble();
      }
      return FlSpot(
        datum.createdAt.millisecondsSinceEpoch.toDouble(),
        datum.moistureHumidity.toDouble(),
      );
    }).toList();

    _mhminX = _moistureHumidityValues.first.x;
    _mhmaxX = _moistureHumidityValues.last.x;
    _mhminY = (minY / _divider).floorToDouble() * _divider;
    _mhmaxY = (maxY / _divider).ceilToDouble() * _divider;

    _mhleftTitlesInterval = 3;
    // ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    if (!mounted) return;

    setState(() {});
  }

  LineChartBarData _humidityLineBarData() {
    return LineChartBarData(
      spots: _humidityValues,
      gradient: LinearGradient(
        colors: _humidityGradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: _humidityGradientColors,
        ),
      ),
    );
  }

  LineChartBarData _lightIntensityLineBarData() {
    return LineChartBarData(
      spots: _lightIntensityValues,
      gradient: LinearGradient(
        colors: _lightIntensityGradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: _lightIntensityGradientColors,
        ),
      ),
    );
  }

  LineChartBarData _temperatureLineBarData() {
    return LineChartBarData(
      spots: _temperatureValues,
      gradient: LinearGradient(
        colors: _temperatureGradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: _temperatureGradientColors,
        ),
      ),
    );
  }

  LineChartBarData _moistureHumidityLineBarData() {
    return LineChartBarData(
      spots: _moistureHumidityValues,
      gradient: LinearGradient(
        colors: _moistureHumidityGradientColors,
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: _moistureHumidityGradientColors,
        ),
      ),
    );
  }

  LineChartData _humidityData() {
    return LineChartData(
      gridData: _humidityGridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
            axisNameWidget: Text("HUMIDITY $currentHumidity%",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            axisNameSize: 30),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: max(1, (_hmaxX - _hminX) / 3),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _hleftTitlesInterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _hminX,
      maxX: _hmaxX,
      minY: _hminY,
      maxY: _hmaxY,
      lineBarsData: [_humidityLineBarData()],
    );
  }

  LineChartData _lightIntensityData() {
    return LineChartData(
      gridData: _lightIntensityGridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
            axisNameWidget: Text("LIGHT INTENSITY $currentLightIntensity LX",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            axisNameSize: 30),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: max(1, (_limaxX - _liminX) / 3),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _lileftTitlesInterval,
            getTitlesWidget: lileftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _liminX,
      maxX: _limaxX,
      minY: _liminY,
      maxY: _limaxY,
      lineBarsData: [_lightIntensityLineBarData()],
    );
  }

  LineChartData _temperatureData() {
    return LineChartData(
      gridData: _temperatureGridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
            axisNameWidget: Text("TEMPERATURE $currentTemperature °C",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            axisNameSize: 30),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: max(1, (_tmaxX - _tminX) / 3),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _tleftTitlesInterval,
            getTitlesWidget: tleftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _tminX,
      maxX: _tmaxX,
      minY: _tminY,
      maxY: _tmaxY,
      lineBarsData: [_temperatureLineBarData()],
    );
  }

  LineChartData _moistureHumidityData() {
    return LineChartData(
      gridData: _moistureHumidityGridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
            axisNameWidget: Text("MOISTURE HUMIDITY $currentMoistureHumidity%",
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            axisNameSize: 30),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: max(1, (_mhmaxX - _mhminX) / 3),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _mhleftTitlesInterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _mhminX,
      maxX: _mhmaxX,
      minY: _mhminY,
      maxY: _mhmaxY,
      lineBarsData: [_moistureHumidityLineBarData()],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    Widget text;
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    text = Text(DateFormat.Md().format(date), style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 13,
    );
    String text = "$value%";
    return Text(text, style: style, textAlign: TextAlign.center);
  }

   Widget lileftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 13,
    );
    String text = "$value lx";
    return Text(text, style: style, textAlign: TextAlign.center);
  }

   Widget tleftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 13,
    );
    String text = "$value °C";
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  FlGridData _humidityGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      verticalInterval: 1,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _hminY) % _hleftTitlesInterval == 0;
      },
    );
  }
  FlGridData _temperatureGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      verticalInterval: 1,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _tminY) % _tleftTitlesInterval == 0;
      },
    );
  }
  FlGridData _lightIntensityGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      verticalInterval: 1,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _liminY) % _lileftTitlesInterval == 0;
      },
    );
  }
  FlGridData _moistureHumidityGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      verticalInterval: 1,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _mhminY) % _mhleftTitlesInterval == 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_humidityValues.isEmpty) {
      return Background(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: const Text('No measurements'),
          ),
        ),
      );
    }
    return Background(
      child: SingleChildScrollView(
        child: Column(children: [
          AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(_lightIntensityData()))),
          AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(_temperatureData()))),
          AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(_humidityData()))),
          AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(_moistureHumidityData()))),
        ]),
      ),
    );
  }
}

Future<List<Measurement>> getMeasurement(int id) async {
  print(id);
  final response = await http.get(
      Uri.parse("http://172.20.10.3:8080/waterit/api/device/$id/history"),
      headers: {HttpHeaders.authorizationHeader: 'Basic $auth'});

  if (response.statusCode == 200) {
    return measurementFromJson(response.body);
  } else {
    throw Exception('Failed to load measurement');
  }
}
