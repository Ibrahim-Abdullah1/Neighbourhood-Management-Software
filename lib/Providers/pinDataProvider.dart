import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinDataNotifier extends ChangeNotifier {
  List<PinData> _pinsData = [];
  List<PinData> _displayedPins = [];
  List<PinData> get pinsData => _pinsData;
  List<PinData> get displayedPins => _displayedPins;

  void addPin(PinData pin) {
    _pinsData.add(pin);
    _displayedPins.add(pin);
    print('Pin added: $pin');
    print('All pins: $pinsData');
    notifyListeners();
  }

  void loadPins(List<PinData> pins) {
    _pinsData = pins;
    notifyListeners();
  }

  void showOwnersOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Owners')).toList();
    notifyListeners();
  }

  void showRiderOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Renter')).toList();
    notifyListeners();
  }

  void showPaidOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Paid')).toList();
    notifyListeners();
  }

  void showUnpaidOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Unpaid')).toList();
    notifyListeners();
  }

  void showkidsOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('kids')).toList();
    notifyListeners();
  }

  void showDogOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Dog')).toList();
    notifyListeners();
  }

  void showPoolOnly() {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains('Pool')).toList();
    notifyListeners();
  }

  void showAllPins() {
    _displayedPins = List.from(_pinsData);
    notifyListeners();
  }

  void hideAllPins() {
    _displayedPins.clear();
    notifyListeners();
  }

  Future<void> deletePinData(String imagePath, PinData pin) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];
    // Find and remove the pin data from storedPins
    String pinJson = jsonEncode(pin.toMap());
    storedPins.remove(pinJson);
    await prefs.setStringList(key, storedPins);
  }

  Future<void> savePinData(String imagePath, PinData pin) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];
    storedPins.add(jsonEncode(pin.toMap()));
    await prefs.setStringList(key, storedPins);
  }

  Future<List<PinData>> retrievePinData(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];
    return storedPins.map((pin) => PinData.fromMap(jsonDecode(pin))).toList();
  }

  // Now, update deletePin method
  Future<void> deletePin(String imagePath, PinData pin) async {
    await deletePinData(imagePath, pin);
    pinsData.remove(pin);
    displayedPins.remove(pin);
    notifyListeners();
  }
}
