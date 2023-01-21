import 'package:flutter/material.dart';
import 'package:flutter_app/screens/plot/components/body.dart';

class PlotScreen extends StatelessWidget {
  final int externalDeviceId;
  const PlotScreen({super.key, required this.externalDeviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        deviceId: externalDeviceId,
      ),
    );
  }
}
