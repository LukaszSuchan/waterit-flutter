import 'package:flutter/material.dart';
import 'package:flutter_app/screens/connect_to_device/connect_to_device_screen.dart';
import 'package:flutter_app/screens/connect_to_wifi/connect_to_wifi.dart';
import 'package:flutter_app/screens/plants/components/body.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return PlantsScreenStage();
  }
}

class PlantsScreenStage extends State<PlantsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plants:",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
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
                        return const ConnectToDeviceScreen();
                      },
                    ),
                  );
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey)),
                child: const Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ConnectToWifiScreen();
                      },
                    ),
                  );
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey)),
                child: const Icon(Icons.settings),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey)),
                child: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
