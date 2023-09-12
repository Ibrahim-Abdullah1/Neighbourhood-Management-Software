import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Model/model.dart';
import 'package:neighborhood_management_software/Providers/pinDataProvider.dart';
import 'package:neighborhood_management_software/Widgets/apptext.dart';
import 'package:provider/provider.dart';
import '../Widgets/CustomCheckBoxes.dart';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  List<String> _titles = [];
  Map<String, List<String>> _categories = {
    'Human Terrain': [
      'Owners',
      'Renter',
      'Paid',
      'Unpaid',
      'kids',
      'Dog',
      'Pool'
    ],
    'Physical Terrain': [],
    'Infrastructure': [],
  };
  String? _selectedCategory;
  String? _selectedCheckbox;

  Map<String, List<String>> selectedItemsByCategory = {};
  List<String> customCheckboxes = [];
  List<PinData> displayedPins = [];
  String? selectedCategory;
  List<String> availableCheckboxes = [];
  String? imagePath;
  Offset? latestTappedPosition;
  List<PinData> pinsData = [];
  final GlobalKey imageKey = GlobalKey();
  Color pinColor = Colors.blue;
  late TextEditingController firstNameController,
      lastNameController,
      addressController,
      SpouseController,
      StreetController,
      EmailController,
      CellPhoneController,
      KidsnameController,
      HisWorkController,
      HerWorkController,
      ChurchController,
      HobbiesController,
      EthnicityController,
      GroupsController,
      SkillsController,
      SocialMediaController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    SpouseController = TextEditingController();
    StreetController = TextEditingController();
    EmailController = TextEditingController();
    CellPhoneController = TextEditingController();
    KidsnameController = TextEditingController();
    HisWorkController = TextEditingController();
    HerWorkController = TextEditingController();
    ChurchController = TextEditingController();
    HobbiesController = TextEditingController();
    EthnicityController = TextEditingController();
    GroupsController = TextEditingController();
    SkillsController = TextEditingController();
    SocialMediaController = TextEditingController();
    loadPins();
    context.read<PinDataNotifier>().showAllPins();
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
      firstNameController.text = pinData.firstName;
      lastNameController.text = pinData.lastName;
      addressController.text = pinData.address;
      SpouseController.text = pinData.spouse;
      StreetController.text = pinData.street;
      EmailController.text = pinData.email;
      CellPhoneController.text = pinData.cellPhone;
      KidsnameController.text = pinData.kidsName;
      HisWorkController.text = pinData.hisWork;
      HerWorkController.text = pinData.herWork;
      ChurchController.text = pinData.church;
      HobbiesController.text = pinData.hobbies;
      EthnicityController.text = pinData.ethnicity;
      GroupsController.text = pinData.groups;
      SkillsController.text = pinData.skills;
      SocialMediaController.text = pinData.socialMedia;
      pinColor = pinData.pinColor;
      selectedItems = pinData.selectedItems;
    } else {
      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      SpouseController.clear();
      StreetController.clear();
      EmailController.clear();
      CellPhoneController.clear();
      KidsnameController.clear();
      HisWorkController.clear();
      HerWorkController.clear();
      ChurchController.clear();
      HobbiesController.clear();
      EthnicityController.clear();
      GroupsController.clear();
      SkillsController.clear();
      SocialMediaController.clear();
      selectedItems.clear();
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final pinNotifier = context.watch<PinDataNotifier>();
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: SpouseController,
                        decoration: InputDecoration(labelText: 'Spouse'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: StreetController,
                        decoration: InputDecoration(labelText: 'Str Address'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: EmailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: CellPhoneController,
                        decoration: InputDecoration(labelText: 'Cell Phone'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: KidsnameController,
                        decoration: InputDecoration(labelText: 'Kids Name'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: HisWorkController,
                        decoration: InputDecoration(labelText: 'His Work'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: HerWorkController,
                        decoration: InputDecoration(labelText: 'Her Work'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: ChurchController,
                        decoration: const InputDecoration(labelText: 'Church'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: HobbiesController,
                        decoration: InputDecoration(labelText: 'Hobbies'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: EthnicityController,
                        decoration: InputDecoration(labelText: 'Ethnicity'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: GroupsController,
                        decoration: InputDecoration(labelText: 'Groups'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: SkillsController,
                        decoration: const InputDecoration(labelText: 'Skills'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.008,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: SocialMediaController,
                        decoration: InputDecoration(labelText: 'Social Media'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 1.0,
                      spacing: 3.0,
                      children: _titles
                          .map((title) => CustomCheckbox(
                                title: title,
                                color: Colors.blue, // or any default color
                                value: selectedItems.contains(title),
                                onChanged: (value) {
                                  handleCheckboxChange(
                                      value, title, selectedItems);
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Color chosenPinColor;
                  if (selectedItems.contains('Owners')) {
                    chosenPinColor = const Color.fromARGB(255, 4, 95, 7);
                  } else if (selectedItems.contains('Renter')) {
                    chosenPinColor = Colors.red;
                  } else if (selectedItems.contains('Paid')) {
                    chosenPinColor = Colors.green;
                  } else if (selectedItems.contains('Unpaid')) {
                    chosenPinColor = Colors.black38;
                  } else if (selectedItems.contains('kids')) {
                    chosenPinColor = Colors.black;
                  } else if (selectedItems.contains('Dog')) {
                    chosenPinColor = const Color.fromARGB(255, 109, 76, 64);
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
                    spouse: SpouseController.text,
                    street: StreetController.text,
                    email: EmailController.text,
                    cellPhone: CellPhoneController.text,
                    kidsName: KidsnameController.text,
                    hisWork: HisWorkController.text,
                    herWork: HerWorkController.text,
                    church: ChurchController.text,
                    hobbies: HobbiesController.text,
                    ethnicity: EthnicityController.text,
                    groups: GroupsController.text,
                    skills: SkillsController.text,
                    socialMedia: SocialMediaController.text,
                    category: SocialMediaController.text,
                    pinColor: chosenPinColor,
                    selectedItemsByCategory: _categories,
                    selectedItems: selectedItems,
                  );
                  await context
                      .read<PinDataNotifier>()
                      .savePinData(imagePath!, pinData);
                  context.read<PinDataNotifier>().addPin(pinData);
                  pinNotifier.displayedPins;
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
              if (pinData != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<PinDataNotifier>()
                          .deletePin(imagePath!, pinData);
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
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
    if (color == const Color.fromARGB(255, 4, 95, 7)) return 'Owners';
    if (color == Colors.red) return 'Renter';
    if (color == Colors.green) return 'Paid';
    if (color == Colors.black38) return 'Unpaid';
    if (color == Colors.black) return 'kids';
    if (color == const Color.fromARGB(255, 82, 51, 40)) return 'Dog';
    if (color == Colors.blue) return 'Pool';
    return 'Qwners'; //default
  }

  void loadPins() async {
    final pins =
        await context.read<PinDataNotifier>().retrievePinData(imagePath!);
    setState(() {
      pinsData = pins;
    });
    context.read<PinDataNotifier>().loadPins(pins);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final pinNotifier = context.watch<PinDataNotifier>();
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
                          onTap: () =>
                              context.read<PinDataNotifier>().showAllPins(),
                          child: const Text(
                            "Summary Pins",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const Expanded(
                          child: Icon(
                            Icons.location_pin,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.read<PinDataNotifier>().hideAllPins(),
                      child: const Text(
                        "Hide All Pins",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Catagories",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = "Human Terrain";
                        });
                      },
                      child: const Text(
                        " Human Terrian",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 4, 95, 7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = "Physical Terrain";
                        });
                      },
                      child: const Text(
                        " Physical Terrian",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 4, 95, 7),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = "Infrastructure";
                        });
                      },
                      child: const Text(
                        " Infrastructure",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 4, 95, 7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: ListView.builder(
                        itemCount: _categories[_selectedCategory]?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _selectedCheckbox =
                                  _categories[_selectedCategory]![index];
                              context.read<PinDataNotifier>().showCheckboxPins(
                                  _categories[_selectedCategory]![index]);
                            },
                            child: ListTile(
                              title:
                                  Text(_categories[_selectedCategory]![index]),
                              trailing: Icon(Icons.location_pin),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Add Checkbox'),
                            content: Column(
                              children: [
                                DropdownButton<String>(
                                  items: _categories.keys
                                      .map((category) =>
                                          DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    _categoryController.text = newValue!;
                                  },
                                  hint: Text("Select a Category"),
                                ),
                                TextField(
                                  controller: _controller,
                                  decoration:
                                      InputDecoration(hintText: "Enter title"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('CANCEL'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('ADD'),
                                onPressed: () {
                                  setState(() {
                                    if (_categoryController.text.isNotEmpty &&
                                        _controller.text.isNotEmpty) {
                                      _categories[_categoryController.text]!
                                          .add(_controller.text);
                                      _titles.add(_controller.text);
                                    }
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Add Checkbox'),
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
                  for (PinData pinData in pinsData) {
                    if ((pinData.position.dx - clickedPosition.dx).abs() < 10 &&
                        (pinData.position.dy - clickedPosition.dy).abs() < 10) {
                      clickedPinData = pinData;
                      print(
                          "Pin clicked at: ${pinData.position}"); // Debug statement
                      break;
                    }
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
                    ...pinNotifier.displayedPins.map((pin) {
                      return Positioned(
                        top: pin.position.dy,
                        left: pin.position.dx,
                        child: InkWell(
                          onTap: () async {
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
