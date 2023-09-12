import 'package:flutter/material.dart';

class PinData {
  Offset position;
  String firstName;
  String lastName;
  String address;
  String spouse;
  String street;
  String email;
  String cellPhone;
  String kidsName;
  String hisWork;
  String herWork;
  String church;
  String hobbies;
  String ethnicity;
  String groups;
  String skills;
  String socialMedia;
  String category;
  Color pinColor;
  List<String> selectedItems;

  PinData({
    required this.position,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.spouse,
    required this.street,
    required this.email,
    required this.cellPhone,
    required this.kidsName,
    required this.hisWork,
    required this.herWork,
    required this.church,
    required this.hobbies,
    required this.ethnicity,
    required this.groups,
    required this.skills,
    required this.socialMedia,
    required this.category,
    required this.pinColor,
    required this.selectedItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': position.dx,
      'y': position.dy,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'spouse': spouse,
      'street': street,
      'email': email,
      'cellPhone': cellPhone,
      'kidsName': kidsName,
      'hisWork': hisWork,
      'herWork': herWork,
      'church': church,
      'hobbies': hobbies,
      'ethnicity': ethnicity,
      'groups': groups,
      'skills': skills,
      'socialMedia': socialMedia,
      'category': category,
      'pinColor': pinColor.value, // storing the int value of the color
      'selectedItems': selectedItems,
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
      spouse: map['spouse'],
      street: map['street'],
      email: map['email'],
      cellPhone: map['cellPhone'],
      kidsName: map['kidsName'],
      hisWork: map['hisWork'],
      herWork: map['herWork'],
      church: map['church'],
      hobbies: map['hobbies'],
      ethnicity: map['ethnicity'],
      groups: map['groups'],
      skills: map['skills'],
      socialMedia: map['socialMedia'],
      category: map['category'],
      pinColor: Color((map['pinColor'] is int)
          ? map['pinColor']
          : int.parse(map['pinColor'].toString())),
      selectedItems: List<String>.from(map['selectedItems']),
    );
  }
}
