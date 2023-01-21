import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class MQTTClientProvider with ChangeNotifier {
  late MqttClient client;

  MQTTClientProvider() {
    client = MqttServerClient.withPort('172.20.10.3', 'flutter_admin', 1883);
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.autoReconnect = true;

    try {
      client.connect();
    } on Exception catch (e) {
      print('Nie udało się połączyć z serwerem: $e');
      return;
    }

    print('Połączono z serwerem');
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
  }

  void publishAndRetainQos1(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
  }

  void disconnect() {
    client.disconnect();
  }
}
