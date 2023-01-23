import 'package:flutter/material.dart';
import 'package:flutter_app/providers/mqtt_client_provider.dart';
import 'package:flutter_app/screens/monitor/monitor_screen.dart';
import 'package:flutter_app/screens/plants/components/background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/components/prefs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  DevicePageState createState() => DevicePageState();
}

class DevicePageState extends State<Body> with AutomaticKeepAliveClientMixin {
  List devices = List.empty();

  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshDevices() async {
    fetchDevices();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchDevices() async {
    var response = await http.get(
      Uri.parse("http://172.20.10.2:8080/waterit/api/device"),
      headers: {'Authorization': 'Basic $auth'},
    );

    devices = json.decode(response.body);
    print(devices.length);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<MQTTClientProvider>(context);
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Background(
      child: RefreshIndicator(
        onRefresh: _refreshDevices,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                itemCount: devices.isEmpty ? 0 : devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
                  print(device['name']);
                  String deviceName = device['name'];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((_) async {
                            try {
                              client.publishAndRetainQos1(
                                  "$deviceName/reset", "true");

                              final success = await _deleteDevice(device["id"]);
                              print(success);
                              if (success == 204) {
                                fetchDevices();
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Błąd przy usuwaniu")));
                            }
                          }),
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              currentDevice = device["name"];
                              return MonitorScreen(device["id"]);
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[300],
                        ),
                        child: Center(
                          child: Text(
                            device['deviceName'],
                            style: TextStyle(
                                color: Colors.grey[850],
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Open Sans',
                                fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  );
                  // ignore: prefer_const_constructors
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: Colors.green,
                    thickness: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> _deleteDevice(int id) async {
  print(auth);
  final response = await http.delete(
    Uri.parse("http://172.20.10.2:8080/waterit/api/device/$id"),
    headers: {'Authorization': 'Basic $auth'},
  );
  if (response.statusCode == 204) {
    print(response.statusCode);
    return 204;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}
