import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home/components/background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        children: const <Widget>[
          
        ],
      ),
    );
  }
}