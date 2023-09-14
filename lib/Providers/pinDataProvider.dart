import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinDataNotifier extends ChangeNotifier {
  List<PinData> _pinsData = [];
  List<PinData> _displayedPins = [];
  List<PinData> get pinsData => _pinsData;
  List<PinData> get displayedPins => _displayedPins;

  List<String> _titles = [];
  List<String> get titles => _titles;

  Map<String, List<String>> _categories = {
    'Human Terrain': [],
    'Physical Terrain': [],
    'Infrastructure': [],
  };

  String _selectedCategory = "";

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String newValue) {
    _selectedCategory = newValue;
    notifyListeners();
  }

  Future<void> saveCheckboxTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "checkbox_titles";
    List<String> storedTitles = prefs.getStringList(key) ?? [];
    storedTitles.add(title);
    await prefs.setStringList(key, storedTitles);
  }

  Future<List<String>> retrieveCheckboxTitles() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "checkbox_titles";
    return prefs.getStringList(key) ?? [];
  }

  Future<void> addCheckbox(String title) async {
    final prefs = await SharedPreferences.getInstance();
    _titles.add(title);
    prefs.setStringList('checkbox_titles', _titles);
    notifyListeners();
  }

  void addCheckboxToCategory(String category, String title) {
    _categories[category]?.add(title);
    addCheckbox(
        title); // the previously defined method to add to _titles and save
  }

  Future<void> loadCheckboxes() async {
    final prefs = await SharedPreferences.getInstance();
    _titles = prefs.getStringList('checkbox_titles') ?? [];
    notifyListeners();
  }

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

  void showCheckboxPins(String checkbox) {
    _displayedPins =
        _pinsData.where((pin) => pin.selectedItems.contains(checkbox)).toList();
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
