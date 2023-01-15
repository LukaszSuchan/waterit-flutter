import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/monitor/components/body.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Monitor")),
      body: Body(),
    );
  }
}