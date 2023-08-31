import 'package:flutter/material.dart';

class Point {
  final double x; // Ranging between 0 and 1
  final double y; // Ranging between 0 and 1

  Point(this.x, this.y);

  factory Point.fromOffset(Offset offset, {required Size imageSize}) {
    return Point(offset.dx / imageSize.width, offset.dy / imageSize.height);
  }

  Offset toOffset(Size imageSize) {
    return Offset(x * imageSize.width, y * imageSize.height);
  }
}
