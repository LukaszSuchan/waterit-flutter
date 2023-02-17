import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/prefs.dart';
import 'package:flutter_app/providers/mqtt_client_provider.dart';
import 'package:flutter_app/screens/login/components/background.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<Body> {
  late FlutterBlue flutterBlue;
  Utf8Encoder encoder = const Utf8Encoder();
  late List<int> request1;
  late List<int> request2;
  late List<int> request3;
  var packets1 = <List<int>>[];
  var packets2 = <List<int>>[];
  var packets3 = <List<int>>[];
  late List<BluetoothDevice> devicesList;
  late bool isScanning;
  JsonCodec json = const JsonCodec();
  late Map wifiCredentials;
  late bool canSave;
  late TextEditingController deviceNameController;
  late bool loading = false;

  // ignore: prefer_const_constructors
  SpinKitRotatingCircle spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  Future<void> findDevices() async {
    devicesList.clear();
    flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: const Duration(seconds: 2));
    // Nasłuchiwanie na znalezione urządzenia
    flutterBlue.scanResults.listen((results) {
      // Przefiltruj urządzenia tak, aby zawierały tylko ESP32
      results.where((r) => r.device.name.startsWith("BLE")).forEach((r) {
        if (!devicesList.contains(r.device)) {
          if (!mounted) return;
          setState(() => devicesList.add(r.device));
          flutterBlue.startScan(timeout: const Duration(milliseconds: 100));
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    request1 = List<int>.empty();
    request2 = List<int>.empty();
    isScanning = true;
    canSave = false;
    devicesList = [];
    deviceNameController = TextEditingController();
    findDevices();

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    devicesList = [];
    deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: loading
          ? spinkit
          : RefreshIndicator(
              onRefresh: findDevices,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      itemCount: devicesList.length,
                      itemBuilder: (context, index) {
                        var device = devicesList[index];
                        return GestureDetector(
                          onTap: () async {
                            device.connect(autoConnect: false).whenComplete(
                              () async {
                                try {
                                  device.requestMtu(512);
                                  final response = await _getWifiCredentials();
                                  wifiCredentials = json.decode(response.body);
                                  final ssid = wifiCredentials["ssid"];
                                  final wifiPassword =
                                      wifiCredentials["wifiPassword"];
                                  final ipServer = wifiCredentials["serverIp"];
                                  request1 =
                                      utf8.encode(json.encode({"S": "$ssid"}));
                                  request2 = utf8.encode(
                                      json.encode({"P": "$wifiPassword"}));
                                  request3 = utf8
                                      .encode(json.encode({"I": "$ipServer"}));
                                  canSave = true;
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Error while parse credentials"),
                                    ),
                                  );
                                }
                                await device.discoverServices().then(
                                  (services) async {
                                    for (var service in services) {
                                      print(service.uuid.toString());
                                      if (service.uuid
                                          .toString()
                                          .startsWith('0000180a')) {
                                        for (var characteristic
                                            in service.characteristics) {
                                          print(characteristic.uuid.toString());
                                          if (characteristic.uuid
                                              .toString()
                                              .startsWith('0000dead')) {
                                            await characteristic.write(
                                                (request1),
                                                withoutResponse: false);
                                          } else if (characteristic.uuid
                                              .toString()
                                              .startsWith('0000deae')) {
                                            await characteristic.write(
                                                (request2),
                                                withoutResponse: false);
                                          } else if (characteristic.uuid
                                              .toString()
                                              .startsWith('0000deaf')) {
                                            await characteristic.write(
                                                (request3),
                                                withoutResponse: true);
                                          }
                                        }
                                      }
                                    }
                                    currentDevice = device.name;
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 29),
                                        content: Row(
                                          children: <Widget>[
                                            const CircularProgressIndicator(),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text(
                                                  "Waiting for activation of $currentDevice"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                    Future.delayed(const Duration(seconds: 30),
                                        () async {
                                      if (await reciveConfirmation(
                                          currentDevice)) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Insert device name"),
                                                  content: TextField(
                                                    autofocus: true,
                                                    controller:
                                                        deviceNameController,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Map data = {
                                                            "name": device.name,
                                                            "deviceName":
                                                                deviceNameController
                                                                    .text,
                                                            "active": true
                                                          };
                                                          var body =
                                                              json.encode(data);
                                                          final responseCode =
                                                              await _addDevice(
                                                                  body);
                                                          print(responseCode);
                                                          device
                                                              .disconnect()
                                                              .whenComplete(() {
                                                            String deviceName =
                                                                device.name;
                                                            String name =
                                                                deviceNameController
                                                                    .text;
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "Sucessfully added $name"),
                                                              ),
                                                            );
                                                            findDevices();
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              devicesList
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          });
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "SUBMIT"))
                                                  ],
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Something went wrong"),
                                                  content: Text(
                                                      "Something went wront while activate of $currentDevice, it's probably lack of wifi"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "SUBMIT"))
                                                  ],
                                                ));
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 80,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[400],
                            ),
                            child: Center(
                              child: Text(
                                device.name,
                                style: TextStyle(
                                    color: Colors.grey[850],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans',
                                    fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

Future<int> _addDevice(String body) async {
  final response = await http.post(
    Uri.parse("http://$globalIpServer:8080/waterit/api/device"),
    headers: {
      'Authorization': 'Basic $auth',
      "Content-Type": "application/json"
    },
    body: body,
  );
  if (response.statusCode == 201) {
    return 201;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}

Future<http.Response> _getWifiCredentials() async {
  final response = await http.get(
    Uri.parse("http://$globalIpServer:8080/waterit/api/account/settings"),
    headers: {'Authorization': 'Basic $auth'},
  );
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}

Future<bool> reciveConfirmation(String device) async {
  final response = await http.get(
    Uri.parse(
        "http://$globalIpServer:8080/waterit/api/device/esp/$device/confirm"),
  );
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return false;
  } else {
    return false;
  }
}
