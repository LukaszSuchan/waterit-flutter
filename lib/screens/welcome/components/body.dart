import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/prefs.dart';
import 'package:flutter_app/components/text_field_container.dart';
import 'package:flutter_app/screens/login/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/screens/signup/signup_screen.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'background.dart';

class Body extends StatelessWidget {
  Body({super.key});
  final TextEditingController serverIpController =
      TextEditingController(text: globalIpServer);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFieldContainer(
              child: TextField(
                controller: serverIpController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.cloud,
                    color: Colors.green,
                  ),
                  hintText: "Ip server",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: const Text(
                "Welcome to WaterIt",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SvgPicture.asset(
              "assets/icons/plant.svg",
              height: size.height * 0.30,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                globalIpServer = serverIpController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                globalIpServer = serverIpController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SignupScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
