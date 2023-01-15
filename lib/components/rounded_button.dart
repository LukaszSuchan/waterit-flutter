import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function()? press;
  const RoundedButton({
    Key? key, 
    required this.text, 
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ButtonStyle loginButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      backgroundColor: Colors.blueGrey,
    );
    return Container(
      width: size.width * 0.7,
      margin: const EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: loginButtonStyle,
          onPressed: press,
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}