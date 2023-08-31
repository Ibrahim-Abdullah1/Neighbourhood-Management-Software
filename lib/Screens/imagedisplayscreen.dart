import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:neighborhood_management_software/Widgets/apptext.dart';
import 'package:neighborhood_management_software/Widgets/dropdownwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  String currentDropdownValue = 'Qwners';
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

  Future<void> deletePinData(String imagePath, PinData pin) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];

    // Find and remove the pin data from storedPins
    String pinJson = jsonEncode(pin.toMap());
    storedPins.remove(pinJson);

    await prefs.setStringList(key, storedPins);
  }

  Future<List<PinData>> retrievePinData(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "pins_$imagePath";
    List<String> storedPins = prefs.getStringList(key) ?? [];
    return storedPins.map((pin) => PinData.fromMap(jsonDecode(pin))).toList();
  }

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    loadPins();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        imagePath = ModalRoute.of(context)!.settings.arguments as String;
        loadPins();
      });
    });
  }

  Future<void> _showPinForm({PinData? pinData}) async {
    if (pinData != null) {
      // If pin data is passed, populate the fields
      firstNameController.text = pinData.firstName;
      lastNameController.text = pinData.lastName;
      addressController.text = pinData.address;
      pinColor = pinData.pinColor;
      currentDropdownValue = pinData.dropdownValue;
    } else {
      // Else, clear the fields
      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      currentDropdownValue = 'Qwners';
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
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
                DropDownWidget(
                    currentDropdownValue: currentDropdownValue,
                    pinColor: pinColor),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final pinData = PinData(
                        position: latestTappedPosition!,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        address: addressController.text,
                        pinColor: pinColor,
                        dropdownValue: currentDropdownValue,
                      );
                      await savePinData(imagePath!, pinData);
                      setState(() {
                        pinsData.add(pinData);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                ),
                if (pinData !=
                    null) // Conditional rendering of the delete button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await deletePinData(imagePath!, pinData);
                        setState(() {
                          pinsData.remove(pinData);
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
        });
      },
    );
  }

  String getColorNameFromColor(Color color) {
    if (color == Color.fromARGB(255, 4, 95, 7)) return 'Qwners';
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
                    const Row(
                      children: [
                        Text(
                          "Summary Pins",
                          style: TextStyle(fontSize: 14),
                        ),
                        Expanded(
                          child: Icon(
                            Icons.location_pin,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Hide All Pins",
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(child: Container()),
                    Text(
                      " Qwners",
                      style: TextStyle(
                          fontSize: 13, color: Color.fromARGB(255, 4, 95, 7)),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      " Renter",
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      " Paid",
                      style: TextStyle(fontSize: 13, color: Colors.green),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      " Unpaid",
                      style: TextStyle(fontSize: 13, color: Colors.black38),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      " kids",
                      style: TextStyle(fontSize: 13, color: Colors.black),
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
                    Text(
                      " Dog",
                      style: TextStyle(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 82, 51, 40)),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Text(
                      " Pool",
                      style: TextStyle(fontSize: 13, color: Colors.green),
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
                    ...pinsData.map((pin) {
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
