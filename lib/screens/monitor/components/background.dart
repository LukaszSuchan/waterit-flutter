import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Widget image;
  final Widget image2;
  const Background({
    Key? key,
    required this.child,
    required this.image, 
    required this.image2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      color: Colors.green,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[child, image, image2],
      ),
    );
  }
}
