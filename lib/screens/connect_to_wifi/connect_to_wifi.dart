import 'package:flutter/material.dart';
import 'package:flutter_app/screens/connect_to_wifi/components/body.dart';

class ConnectToWifiScreen extends StatelessWidget {
  const ConnectToWifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: Body(),
    );
  }
}