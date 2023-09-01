import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:neighborhood_management_software/Widgets/apptext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/CustomCheckBoxes.dart';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  bool pinmark = false;
  List<PinData> displayedPins = [];
  String dropdownValue = "";
  String? imagePath;
  Offset? latestTappedPosition; // Add this line
  List<PinData> pinsData = [];
  List<Offset> tappedPositionsRatios = [];
  final GlobalKey imageKey = GlobalKey();
  Offset? tappedRelativePosition;
  Offset? tappedPosition;
  Color pinColor = Colors.blue;
  late TextEditingController firstNameController,
      lastNameController,
      addressController;

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

  Future<void> deletePinData(String imagePath, PinData pin) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];

    // Find and remove the pin data from storedPins
    String pinJson = jsonEncode(pin.toMap());
    storedPins.remove(pinJson);

    await prefs.setStringList(key, storedPins);
  }

  void showOwnersOnly() {
    setState(() {
      displayedPins = pinsData
          .where((pin) => pin.selectedItems.contains('Owners'))
          .toList();
    });
  }

  void showRiderOnly() {
    setState(() {
      displayedPins = pinsData
          .where((pin) => pin.selectedItems.contains('Renter'))
          .toList();
    });
  }

  void showPaidOnly() {
    setState(() {
      displayedPins =
          pinsData.where((pin) => pin.selectedItems.contains('Paid')).toList();
    });
  }

  void showUnpaidOnly() {
    setState(() {
      displayedPins = pinsData
          .where((pin) => pin.selectedItems.contains('Unpaid'))
          .toList();
    });
  }

  void showkidsOnly() {
    setState(() {
      displayedPins =
          pinsData.where((pin) => pin.selectedItems.contains('kids')).toList();
    });
  }

  void showDogOnly() {
    setState(() {
      displayedPins =
          pinsData.where((pin) => pin.selectedItems.contains('Dog')).toList();
    });
  }

  void showPoolOnly() {
    setState(() {
      displayedPins =
          pinsData.where((pin) => pin.selectedItems.contains('Pool')).toList();
    });
  }

  void showAllPins() {
    setState(() {
      displayedPins = List.from(pinsData);
    });
  }

  void hideAllPins() {
    setState(() {
      displayedPins.clear();
    });
  }

// Add other filtering methods as needed

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    loadPins();
    showAllPins();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        imagePath = ModalRoute.of(context)!.settings.arguments as String;
        loadPins();
      });
    });
  }

  Future<void> _showPinForm({PinData? pinData}) async {
    List<String> selectedItems = [];
    if (pinData != null) {
      // If pin data is passed, populate the fields
      firstNameController.text = pinData.firstName;
      lastNameController.text = pinData.lastName;
      addressController.text = pinData.address;
      pinColor = pinData.pinColor;
      selectedItems = pinData.selectedItems;
    } else {
      // Else, clear the fields
      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      selectedItems.clear();
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  CustomCheckbox(
                    title: 'Owners',
                    color: Color.fromARGB(255, 4, 95, 7),
                    value: selectedItems.contains('Owners'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Owners', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'Renter',
                    color: Colors.red,
                    value: selectedItems.contains('Renter'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Renter', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'Paid',
                    color: Colors.green,
                    value: selectedItems.contains('Paid'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Paid', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'Unpaid',
                    color: Colors.black38,
                    value: selectedItems.contains('Unpaid'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Unpaid', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'kids',
                    color: Colors.black,
                    value: selectedItems.contains('kids'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'kids', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'Dog',
                    color: Color.fromARGB(255, 82, 51, 40),
                    value: selectedItems.contains('Dog'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Dog', selectedItems);
                    },
                  ),
                  CustomCheckbox(
                    title: 'Pool',
                    color: Colors.blue,
                    value: selectedItems.contains('Pool'),
                    onChanged: (value) {
                      handleCheckboxChange(value, 'Pool', selectedItems);
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  Color chosenPinColor;
                  if (selectedItems.contains('Owners')) {
                    chosenPinColor = Color.fromARGB(255, 4, 95, 7);
                  } else if (selectedItems.contains('Renter')) {
                    chosenPinColor = Colors.red;
                  } else if (selectedItems.contains('Paid')) {
                    chosenPinColor = Colors.green;
                  } else if (selectedItems.contains('Unpaid')) {
                    chosenPinColor = Colors.black38;
                  } else if (selectedItems.contains('kids')) {
                    chosenPinColor = Colors.black;
                  } else if (selectedItems.contains('Dog')) {
                    chosenPinColor = Color.fromARGB(255, 82, 51, 40);
                  } else if (selectedItems.contains('Pool')) {
                    chosenPinColor = Colors.blue;
                  } else {
                    chosenPinColor = Colors.deepOrangeAccent;
                  }
                  final pinData = PinData(
                    position: latestTappedPosition!,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    address: addressController.text,
                    pinColor: chosenPinColor,
                    selectedItems: selectedItems,
                  );
                  await savePinData(imagePath!, pinData);
                  setState(() {
                    pinsData.add(pinData);
                    displayedPins.add(pinData);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
              if (pinData != null) // Conditional rendering of the delete button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await deletePinData(imagePath!, pinData);
                      setState(() {
                        pinsData.remove(pinData);
                        displayedPins.remove(pinData);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Foreground color
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void handleCheckboxChange(
      bool value, String item, List<String> selectedItems) {
    if (value) {
      selectedItems.add(item);
    } else {
      selectedItems.remove(item);
    }
  }

  String getColorNameFromColor(Color color) {
    if (color == Color.fromARGB(255, 4, 95, 7)) return 'Owners';
    if (color == Colors.red) return 'Renter';
    if (color == Colors.green) return 'Paid';
    if (color == Colors.black38) return 'Unpaid';
    if (color == Colors.black) return 'kids';
    if (color == Color.fromARGB(255, 82, 51, 40)) return 'Dog';
    if (color == Colors.blue) return 'Pool';
    return 'Qwners'; // default
  }

  void loadPins() async {
    final pins = await retrievePinData(imagePath!);
    setState(() {
      pinsData =
          pins; // pinsData should be a List<PinData> defined in your state class.
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final imagePath = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                border: Border.all(
                  width: 3.0,
                  color: Colors.blue,
                ),
              ),
              height: screenHeight,
              width: screenWidth * 0.125,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: "Data",
                      size: screenWidth * 0.025,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: showAllPins,
                          child: Text(
                            "Summary Pins",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.location_pin,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: hideAllPins,
                      child: const Text(
                        "Hide All Pins",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: showOwnersOnly,
                      child: Text(
                        " Owners",
                        style: TextStyle(
                            fontSize: 13, color: Color.fromARGB(255, 4, 95, 7)),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showRiderOnly,
                      child: Text(
                        " Renter",
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showPaidOnly,
                      child: Text(
                        " Paid",
                        style: TextStyle(fontSize: 13, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showUnpaidOnly,
                      child: Text(
                        " Unpaid",
                        style: TextStyle(fontSize: 13, color: Colors.black38),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showkidsOnly,
                      child: Text(
                        " kids",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      "------",
                      style: TextStyle(fontSize: 17, color: Colors.green),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showDogOnly,
                      child: Text(
                        " Dog",
                        style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 82, 51, 40)),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    GestureDetector(
                      onTap: showPoolOnly,
                      child: Text(
                        " Pool",
                        style: TextStyle(fontSize: 13, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTapUp: (details) async {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset clickedPosition =
                      renderBox.globalToLocal(details.globalPosition);
                  PinData? clickedPinData;

                  // Check if clicked near any existing pin
                  for (PinData pinData in pinsData) {
                    if ((pinData.position.dx - clickedPosition.dx).abs() < 10 &&
                        (pinData.position.dy - clickedPosition.dy).abs() < 10) {
                      clickedPinData = pinData;
                      print(
                          "Pin clicked at: ${pinData.position}"); // Debug statement
                      break;
                    }
                  }

                  if (clickedPinData != null) {
                    // Fill the form with the data of the clicked pin
                    firstNameController.text = clickedPinData.firstName;
                    lastNameController.text = clickedPinData.lastName;
                    addressController.text = clickedPinData.address;
                    pinColor = clickedPinData.pinColor;
                  } else {
                    // Clear the form for a new pin
                    firstNameController.clear();
                    lastNameController.clear();
                    addressController.clear();
                  }

                  setState(() {
                    latestTappedPosition = details.localPosition;
                  });
                  await _showPinForm();
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                        key: imageKey,
                      ),
                    ),
                    ...displayedPins.map((pin) {
                      return Positioned(
                        top: pin.position.dy,
                        left: pin.position.dx,
                        child: InkWell(
                          onTap: () async {
                            // Display pin's data using a dialog, bottom sheet, or any other method.
                            await _showPinForm(pinData: pin);
                          },
                          child: Icon(
                            Icons.location_pin,
                            color: pin.pinColor,
                            size: 30,
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
