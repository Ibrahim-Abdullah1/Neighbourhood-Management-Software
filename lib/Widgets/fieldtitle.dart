import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {
  String title;
  FieldTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
