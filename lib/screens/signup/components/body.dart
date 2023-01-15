import 'package:flutter/material.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/text_field_container.dart';
import 'package:flutter_app/screens/login/login_screen.dart';
import 'package:flutter_app/screens/signup/components/background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white),
          ),
          Image.asset(
            "assets/images/register.png",
            width: size.width * 0.6,
          ),
          const TextFieldContainer(
            child: TextField(
              // onChanged: (value) {},
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                hintText: "Your Email",
                border: InputBorder.none,
              ),
            ),
          ),
          const TextFieldContainer(
            child: TextField(
              // onChanged: (value) {},
              obscureText: true,
              decoration: InputDecoration(
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
          RoundedButton(text: "SIGNUP", press: () {}),
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
    );
  }
}
