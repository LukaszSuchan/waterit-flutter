import 'package:flutter/material.dart';
import 'package:flutter_app/screens/connect_to_device/components/body.dart';

class ConnectToDeviceScreen extends StatelessWidget {
  const ConnectToDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Select device",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: Body(),
    );
  }
}