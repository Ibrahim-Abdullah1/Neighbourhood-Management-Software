import 'package:flutter/material.dart';

class PinData {
  Offset position;
  String firstName;
  String lastName;
  String address;
  Color pinColor;

  PinData({
    required this.position,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.pinColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': position.dx,
      'y': position.dy,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'pinColor': pinColor.value, // storing the int value of the color
    };
  }

  static PinData fromMap(Map<String, dynamic> map) {
    return PinData(
      position: Offset(map['x'], map['y']),
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      pinColor: Color(map['pinColor']),
    );
  }
}
