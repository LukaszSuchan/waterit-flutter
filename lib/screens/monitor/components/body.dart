// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/monitor/components/background.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_app/components/prefs.dart';

class Body extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyMQTTPageState createState() => _MyMQTTPageState();
  late final String deviceName;
}

class _MyMQTTPageState extends State<Body> with WidgetsBindingObserver {
  String param1 = '-';
  String param2 = '-';
  String param3 = '-';
  String param4 = '-';
  late MqttClient client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  @override
  void dispose() {
    client.disconnect(); // rozłączenie z serwerem MQTT
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void connect() async {
    client = MqttServerClient.withPort('$globalIpServer', 'flutter_01', 1883);
    client.onConnected = onConnected;
    client.logging(on: true);
    client.keepAlivePeriod = 30;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('Nie udało się połączyć z serwerem: $e');
      return;
    }

    print('Połączono z serwerem');
  }

  void onConnected() {
    subscribe('$currentDevice/lux');
    subscribe('$currentDevice/temperature');
    subscribe('$currentDevice/humidity');
    subscribe('$currentDevice/moisture');
  }

  void subscribe(String topic) async {
    client.subscribe(topic, MqttQos.exactlyOnce);

    print('Subskrybowano $topic');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final messageRec = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(messageRec.payload.message);
      final String decodedMessage = utf8.decode(message.codeUnits);

      // Przypisz odpowiednią wartość do parametrów
      if (c[0].topic == '$currentDevice/lux') {
        setState(() {
          param1 = decodedMessage;
          print(decodedMessage);
        });
      } else if (c[0].topic == '$currentDevice/temperature') {
        setState(() {
          param2 = decodedMessage;
          print(decodedMessage);
        });
      } else if (c[0].topic == '$currentDevice/humidity') {
        setState(() {
          param3 = decodedMessage;
          print(decodedMessage);
        });
      } else if (c[0].topic == '$currentDevice/moisture') {
        setState(() {
          param4 = message;
        });
      }
    });
  }

  String sanitize(String s) => s.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle textStyle = TextStyle(
        color: Colors.grey[850],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        fontFamily: 'Open Sans',
        fontSize: 18);
    TextStyle textStyleForParams = TextStyle(
        color: Colors.grey[850],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        fontFamily: 'Open Sans',
        fontSize: 30);
    RoundedRectangleBorder cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    );
    return Background(
      image: Padding(
        padding: const EdgeInsets.only(top: 600),
        child: Image.asset(
          "assets/images/ecology.png",
          width: size.width * 0.6,
        ),
      ),
      image2: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(top: 50),
        margin: const EdgeInsets.only(right: 60),
        child: Image.asset(
          "assets/images/gardening.png",
          width: size.width * 0.3,
        ),
      ),
      child: GridView.count(
        padding: const EdgeInsets.only(top: 190, left: 20, right: 20),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          Card(
            shape: cardShape,
            color: const Color.fromARGB(255, 249, 178, 214),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Light intensity',
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      '$param1 lux',
                      style: textStyleForParams,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: cardShape,
            color: Color.fromARGB(255, 255, 165, 79),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Temperature',
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      sanitize('$param2 °C'),
                      style: textStyleForParams,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: cardShape,
            color: Color.fromARGB(255, 91, 132, 254),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Humidity',
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      '$param3 %',
                      style: textStyleForParams,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: cardShape,
            color: Color.fromARGB(255, 0, 212, 152),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Moisture humidity',
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      '$param4 %',
                      style: textStyleForParams,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
