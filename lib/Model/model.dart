import 'package:flutter/material.dart';

class PinData {
  Offset position;
  String firstName;
  String lastName;
  String address;
  Color pinColor;
  String dropdownValue;

  PinData({
    required this.position,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.pinColor,
    required this.dropdownValue, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'x': position.dx,
      'y': position.dy,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'pinColor': pinColor.value, // storing the int value of the color
      'dropdownValue': dropdownValue,
    };
  }

  static PinData fromMap(Map<String, dynamic> map) {
    return PinData(
      position: Offset(
          (map['x'] is double) ? map['x'] : double.parse(map['x'].toString()),
          (map['y'] is double) ? map['y'] : double.parse(map['y'].toString())),
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      pinColor: Color((map['pinColor'] is int)
          ? map['pinColor']
          : int.parse(map['pinColor'].toString())),
      dropdownValue: map['dropdownValue'],
    );
  }
}
