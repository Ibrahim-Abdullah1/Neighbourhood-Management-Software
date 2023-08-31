import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:neighborhood_management_software/Widgets/apptext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
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
                  Size imageSize = renderBox.size;

                  setState(() {
                    latestTappedPosition = details.localPosition;
                  });

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: firstNameController,
                              decoration:
                                  InputDecoration(labelText: 'First Name'),
                            ),
                            TextFormField(
                              controller: lastNameController,
                              decoration:
                                  InputDecoration(labelText: 'Last Name'),
                            ),
                            TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(labelText: 'Address'),
                            ),
                            DropdownButton<String>(
                              value:
                                  'Qwners', // Default value for the sake of demonstration
                              items: <String>[
                                'Qwners',
                                'Renter',
                                'Paid',
                                'Unpaid',
                                'kids',
                                'Dog',
                                'Pool'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  switch (newValue) {
                                    case 'Qwners':
                                      pinColor = Color.fromARGB(255, 4, 95, 7);
                                      break;
                                    case 'Renter':
                                      pinColor = Colors.red;
                                      break;
                                    case 'Paid':
                                      pinColor = Colors.green;
                                      break;
                                    case 'Unpaid':
                                      pinColor = Colors.black38;
                                      break;
                                    case 'kids':
                                      pinColor = Colors.black;
                                      break;
                                    case 'Dog':
                                      pinColor =
                                          Color.fromARGB(255, 82, 51, 40);
                                      break;
                                    case 'Pool':
                                      pinColor = Colors.green;
                                      break;
                                    default:
                                      pinColor = Colors.blue;
                                  }
                                }
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final pinData = PinData(
                                  position: latestTappedPosition!,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  address: addressController.text,
                                  pinColor: pinColor,
                                );
                                await savePinData(imagePath, pinData);
                                setState(() {
                                  pinsData.add(pinData);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
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
                          onTap: () {
                            // Display pin's data using a dialog, bottom sheet, or any other method.
                            // You have access to pin.firstName, pin.lastName, etc.
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







// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:neighborhood_management_software/Utilis/pin.dart';
// import 'package:neighborhood_management_software/Widgets/apptext.dart';
// import 'package:neighborhood_management_software/Widgets/formcheckbox.dart';

// class ShowImage extends StatefulWidget {
//   ShowImage({super.key});

//   @override
//   State<ShowImage> createState() => _ShowImageState();
// }

// class _ShowImageState extends State<ShowImage> {
//   String? currentCheckboxTitle;
//   OverlayEntry? formOverlay;
//   List<Pin> pins = [];
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   final imageKey = GlobalKey();

//   @override
//   void dispose() {
//     // Clean up the overlay when the widget is disposed to avoid lingering overlays
//     formOverlay?.remove();
//     super.dispose();
//   }

//   Color determineColor(String? checkboxTitle) {
//     switch (checkboxTitle) {
//       case 'Qwners':
//         return Color.fromARGB(255, 4, 95, 7);
//       case 'Renter':
//         return Colors.red;
//       case 'Paid':
//         return Colors.green;
//       case 'Unpaid':
//         return Colors.black38;
//       case 'kids':
//         return Colors.black;
//       case "Dog":
//         return Color.fromARGB(255, 82, 51, 40);
//       case "Pool":
//         return Colors.green;
//       default:
//         return Colors.blue; // Default color
//     }
//   }

//   Offset calculatePixelPosition(Offset absolutePosition) {
//     final imageBox = imageKey.currentContext?.findRenderObject() as RenderBox?;
//     if (imageBox == null) return Offset(-1, -1);

//     final imagePosition = imageBox.localToGlobal(Offset.zero);
//     final imageSize = imageBox.size;

//     // Calculate pixel position
//     if (absolutePosition.dx >= imagePosition.dx &&
//         absolutePosition.dx <= imagePosition.dx + imageSize.width &&
//         absolutePosition.dy >= imagePosition.dy &&
//         absolutePosition.dy <= imagePosition.dy + imageSize.height) {
//       return Offset(
//         absolutePosition.dx - imagePosition.dx,
//         absolutePosition.dy - imagePosition.dy,
//       );
//     }

//     return Offset(-1, -1); // Indicate the click was outside the image.
//   }

//   void handleCheckboxChange(String title) {
//     setState(() {
//       currentCheckboxTitle = title;
//     });
//   }

//   OverlayEntry createFormOverlay(Pin pin, BuildContext context) {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final globalPosition = renderBox.localToGlobal(pin.relativePosition);
//     double formWidth = MediaQuery.of(context).size.width * 0.3;
//     double formHeight = MediaQuery.of(context).size.height * 0.6;
//     double formLeft =
//         globalPosition.dx + formWidth > MediaQuery.of(context).size.width
//             ? globalPosition.dx - formWidth
//             : globalPosition.dx;
//     double formTop =
//         globalPosition.dy + formHeight > MediaQuery.of(context).size.height
//             ? globalPosition.dy - formHeight
//             : globalPosition.dy;

//     return OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           left: formLeft,
//           top: formTop,
//           child: GestureDetector(
//             onTap: () {
//               // Close the form overlay
//               formOverlay?.remove();
//             },
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 height: MediaQuery.of(context).size.height * 0.55,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 padding: EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Expanded(
//                               child: TextField(
//                                   decoration: InputDecoration(
//                                       labelText: 'First Name'))),
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.015),
//                           const Expanded(
//                               child: TextField(
//                                   decoration:
//                                       InputDecoration(labelText: 'Last Name'))),
//                         ],
//                       ),
//                       SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.015),
//                       TextField(
//                           decoration: InputDecoration(labelText: 'Address')),
//                       SizedBox(
//                           height: MediaQuery.of(context).size.width * 0.015),
//                       TextField(
//                           decoration:
//                               InputDecoration(labelText: 'Phone Number')),
//                       SizedBox(
//                           height: MediaQuery.of(context).size.width * 0.01),
//                       Wrap(
//                         spacing: 20,
//                         runSpacing: 10,
//                         children: [
//                           FormCheckBox(
//                             title: 'Qwners',
//                             isChecked: currentCheckboxTitle == 'Qwners',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Renters',
//                             isChecked: currentCheckboxTitle == 'Renters',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Paid',
//                             isChecked: currentCheckboxTitle == 'Paid',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Unpaid',
//                             isChecked: currentCheckboxTitle == 'Unpaid',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Kids',
//                             isChecked: currentCheckboxTitle == 'Kids',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Dogs',
//                             isChecked: currentCheckboxTitle == 'Dogs',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                           FormCheckBox(
//                             title: 'Pool',
//                             isChecked: currentCheckboxTitle == 'Pool',
//                             onCheckboxChanged: (title) {
//                               setState(() {
//                                 currentCheckboxTitle = title;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                           height: MediaQuery.of(context).size.width * 0.015),
//                       Align(
//                         alignment: Alignment.center,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               if (pins.isNotEmpty) {
//                                 // assuming that the last pin is the one that's being edited
//                                 pins.last.color = determineColor(
//                                     currentCheckboxTitle); // A function you can create to get color based on checkbox title.
//                               }
//                             });
//                             // Handle form submission
//                             formOverlay?.remove();
//                             formOverlay = null;
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.blue,
//                             padding: EdgeInsets.symmetric(horizontal: 30),
//                           ),
//                           child: Text(
//                             'Submit',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ), // Continue with your Material design and children
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void addPin(Offset pixelPosition) {
//     Color pinColor;
//     SchedulerBinding.instance!.addPostFrameCallback((timeStamp){
//     switch (currentCheckboxTitle) {
//       case 'Qwners':
//         pinColor = Color.fromARGB(255, 4, 95, 7);
//         break;
//       case 'Renter':
//         pinColor = Colors.red;
//         break;
//       case 'Paid':
//         pinColor = Colors.green;
//         break;
//       case 'Unpaid':
//         pinColor = Colors.black38;
//         break;
//       case 'kids':
//         pinColor = Colors.black;
//         break;
//       case 'Dog':
//         pinColor = Color.fromARGB(255, 82, 51, 40);
//         break;
//       case 'Pool':
//         pinColor = Colors.green;
//         break;
//       default:
//         pinColor = Colors.blue; // Default color
//     }
//     final imageSize =
//         (imageKey.currentContext?.findRenderObject() as RenderBox?)?.size;

//     if (imageSize != null) {
//       final Offset relativePosition = Offset(
//         pixelPosition.dx / imageSize.width,
//         pixelPosition.dy / imageSize.height,
//       );

//       setState(() {
//         final newPin = Pin(relativePosition: relativePosition, color: pinColor);
//         pins.add(newPin);

//         // Remove the old overlay
//         formOverlay?.remove();

//         // Create a new overlay
//         formOverlay = createFormOverlay(newPin, context);

//         // Insert the new overlay
//         Overlay.of(context).insert(formOverlay!);
//       });
//     } 
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final imagePath = ModalRoute.of(context)!.settings.arguments as String;
//     return Scaffold(
//       body: Container(
//         child: ListView(scrollDirection: Axis.horizontal, children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white54,
          //     border: Border.all(
          //       width: 3.0,
          //       color: Colors.blue,
          //     ),
          //   ),
          //   height: screenHeight,
          //   width: screenWidth * 0.125,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         AppLargeText(
          //           text: "Data",
          //           size: screenWidth * 0.025,
          //         ),
          //         const Row(
          //           children: [
          //             Text(
          //               "Summary Pins",
          //               style: TextStyle(fontSize: 14),
          //             ),
          //             Expanded(
          //               child: Icon(
          //                 Icons.location_pin,
          //                 size: 15,
          //               ),
          //             ),
          //           ],
          //         ),
          //         const Text(
          //           "Hide All Pins",
          //           style: TextStyle(fontSize: 14),
          //         ),
          //         Expanded(child: Container()),
          //         Text(
          //           " Qwners",
          //           style: TextStyle(
          //               fontSize: 13, color: Color.fromARGB(255, 4, 95, 7)),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " Renter",
          //           style: TextStyle(fontSize: 13, color: Colors.red),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " Paid",
          //           style: TextStyle(fontSize: 13, color: Colors.green),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " Unpaid",
          //           style: TextStyle(fontSize: 13, color: Colors.black38),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " kids",
          //           style: TextStyle(fontSize: 13, color: Colors.black),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           "------",
          //           style: TextStyle(fontSize: 17, color: Colors.green),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " Dog",
          //           style: TextStyle(
          //               fontSize: 13,
          //               color: const Color.fromARGB(255, 82, 51, 40)),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.005,
          //         ),
          //         Text(
          //           " Pool",
          //           style: TextStyle(fontSize: 13, color: Colors.green),
          //         ),
          //         SizedBox(
          //           height: screenHeight * 0.1,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
//           Expanded(
//             child: GestureDetector(
//               onTapDown: (details) {
//                 final pixelPosition =
//                     calculatePixelPosition(details.globalPosition);

//                 if (pixelPosition.dx != -1 && pixelPosition.dy != -1) {
//                   addPin(pixelPosition);

//                   // Remove the old overlay
//                   formOverlay?.remove();

//                   // Create a new overlay
//                   formOverlay = createFormOverlay(
//                       Pin(relativePosition: pixelPosition), context);

//                   // Insert the new overlay
//                   Overlay.of(context).insert(formOverlay!);
//                 }
//               },
//               child: Container(
//                 child: Stack(children: [
//                   Image.file(
//                     File(imagePath),
//                     fit: BoxFit.contain,
//                     key: imageKey, // Attach the global key here
//                   ),
//                   for (var pin in pins)
//                     Positioned(
//                       left: (imageKey.currentContext?.size?.width ?? 0) *
//                               pin.relativePosition.dx -
//                           10,
//                       top: (imageKey.currentContext?.size?.height ?? 0) *
//                               pin.relativePosition.dy -
//                           20,
//                       child: GestureDetector(
//                         onTap: () {
//                           // Same logic to show the form overlay for existing pins
//                           formOverlay?.remove();
//                           formOverlay = createFormOverlay(pin, context);
//                           Overlay.of(context).insert(formOverlay!);
//                         },
//                         child: Icon(Icons.location_pin,
//                             size: 30, color: pin.color),
//                       ),
//                     ),
//                 ]),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
