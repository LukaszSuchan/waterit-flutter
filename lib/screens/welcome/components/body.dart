import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/screens/signup/signup_screen.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
    );
  }
}
