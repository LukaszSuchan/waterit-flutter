import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/text_field_container.dart';
import 'package:flutter_app/screens/login/login_screen.dart';
import 'package:flutter_app/screens/signup/components/background.dart';
import 'package:http/http.dart' as http;

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
          children: <Widget>[
            const Text(
              "SIGNUP",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Image.asset(
              "assets/images/register.png",
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
              text: "SIGNUP",
              press: () async {
                try {
                  final success = await _attemptRegister(
                      emailController.text, passwordController.text);
                  print(success);
                  if (success == 201) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Successful signup")));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error while signup")));
                }
              },
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Already have an Account ?  ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
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

Future<int> _attemptRegister(String username, String password) async {
  Map data = {"email": username, "password": password, "enabled": true};
  var body = json.encode(data);
  final response = await http.post(
      Uri.parse("http://172.20.10.2:8080/waterit/api/account/register"),
      headers: {"Content-Type": "application/json"},
      body: body);
  if (response.statusCode == 201) {
    return 201;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception("Wystąpił nieoczekiwany błąd");
  }
}
