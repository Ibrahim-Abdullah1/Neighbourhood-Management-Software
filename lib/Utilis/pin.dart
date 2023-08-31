import 'package:flutter/material.dart';

class Pin {
  final Offset
      relativePosition; // Store relative positions (values between 0 and 1)
  late final Color color;

  Pin({required this.relativePosition, this.color = Colors.black});
}
