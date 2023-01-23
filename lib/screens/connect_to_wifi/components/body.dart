import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/prefs.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/providers/mqtt_client_provider.dart';
import 'package:flutter_app/screens/login/components/background.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<Body> {
  // late NetworkInfo info;
  String ssid = "ssid";

  @override
  void initState() {
    super.initState();
    // info = NetworkInfo();
    // getWifiSsid();
  }

  // void getWifiSsid() async {
  //   // final ssidqq = (await info.getWifiName()) ?? "'could't load'";
  //   // final ssidq = ssidqq.substring(1);
  //   List<String> c = ssidq.split("");
  //   c.removeLast();
  //   ssid = c.join();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> refreshSsid() async {
  //   getWifiSsid();
  //   setState(() {
  //     getWifiSsid();
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<MQTTClientProvider>(context);
    Size size = MediaQuery.of(context).size;
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController ssidController = TextEditingController();
    final TextEditingController serverIpController = TextEditingController();
    final TextEditingController intervalController = TextEditingController();
    final TextEditingController measurementIntervalController =
        TextEditingController();

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "To server:",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("SSID"),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: TextField(
                  readOnly: false,
                  controller: ssidController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "SSID",
                  ),
                ),
              ),
            ),
            const Text("Wifi password"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.visibility, color: Colors.green),
                  hintText: "WiFi password",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            const Text("Server IP"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: serverIpController,
                decoration: const InputDecoration(
                  hintText: "Server IP",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
              height: 20,
              color: Colors.blueGrey,
            ),
            const Text(
              "To esp:",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Resolution of light intensity sensor (0.5 lx/1 lx):"),
            Transform.scale(
              scale: 1.75,
              child: Switch(
                // This bool value toggles the switch.
                value: light,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    light = value;
                    if (value == true) {
                      client.publish('bh1750/resolution', 'high');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "light sensor resolution will be set to HIGH in next wake-up")));
                    } else {
                      client.publish('bh1750/resolution', 'low');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "light sensor resolution will be set to LOW in next wake-up")));
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            const Text("esp 32 wake up interval (seconds):"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: intervalController,
                decoration: const InputDecoration(
                  hintText: "Wake up interval",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            const Text("esp32 measurement interval (seconds):"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: measurementIntervalController,
                decoration: const InputDecoration(
                  hintText: "Measurement interval",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            RoundedButton(
                text: "Send",
                press: () async {
                  if (intervalController.text != "") {
                    String interval = intervalController.text;
                    client.publish("esp32/interval", interval);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "wake up interval will be set to $interval in next wake-up"),
                      ),
                    );
                  }
                  if (measurementIntervalController.text != "") {
                    String interval = measurementIntervalController.text;
                    client.publish("esp32/measurement-interval", interval);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "measurement interval will be set to $interval in next wake-up"),
                      ),
                    );
                  }
                  Map data = {
                    "ssid": ssidController.text,
                    "wifiPassword": ssidController.text,
                    "serverIp": serverIpController.text,
                  };
                  bool toSend = false;
                  if (ssidController.text.isNotEmpty) {
                    data["ssid"] = ssidController.text;
                    toSend = true;
                  }
                  if (passwordController.text.isNotEmpty) {
                    data["wifiPassword"] = passwordController.text;
                    toSend = true;
                  }
                  if (ssidController.text.isNotEmpty) {
                    data["serverIp"] = serverIpController.text;
                    toSend = true;
                  }
                  if (toSend) {
                    var body = json.encode(data);
                    final responseCode = await postCredentials(body);
                    print(responseCode);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Settings saved")));
                  }
                }),
            SizedBox(
              height: size.height * 0.025,
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> postCredentials(String body) async {
  final response = await http.post(
    Uri.parse("http://172.20.10.2:8080/waterit/api/account/settings"),
    headers: {
      'Authorization': 'Basic $auth',
      'Content-Type': "application/json"
    },
    body: body,
  );
  if (response.statusCode == 204) {
    return 204;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}
