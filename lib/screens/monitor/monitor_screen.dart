import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/monitor/components/body.dart';
import 'package:flutter_app/screens/plot/home_screen.dart';

class MonitorScreen extends StatelessWidget {
  int deviceId;
  MonitorScreen(this.deviceId, {super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Monitor")),
      body: Body(),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 107, 236, 112),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlotScreen(externalDeviceId: deviceId,);
                      },
                    ),
                  );
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey)),
                child: const Icon(Icons.history),
              ),
            ],
          ),)
      ),
    );
  }
}