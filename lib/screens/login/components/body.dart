import 'package:flutter/material.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/text_field_container.dart';
import 'package:flutter_app/screens/login/components/background.dart';
import 'package:flutter_app/screens/plants/plants_screen.dart';
import 'package:flutter_app/screens/signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/prefs.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Image.asset(
              "assets/images/water_plant.png",
              width: size.width * 0.6,
            ),
            TextFieldContainer(
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  hintText: "Your Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.green,
                  ),
                  suffixIcon: Icon(Icons.visibility, color: Colors.green),
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                try {
                  final success = await _attemptLogin(
                      emailController.text, passwordController.text);
                  print(success);
                  if (success == 200) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const PlantsScreen();
                        },
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Incorrect login or password")));
                }
              },
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an Account ?  ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SignupScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<int> _attemptLogin(String username, String password) async {
  auth = base64.encode(utf8.encode('$username:$password'));
  final response = await http.get(
    Uri.parse("http://192.168.0.81:8080/waterit/api/account"),
    headers: {'Authorization': 'Basic $auth'},
  );
  var x = 1;
  if (response.statusCode == 200) {
    return 200;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}
