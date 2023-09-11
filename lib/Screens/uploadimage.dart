import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _lastSelectedImagePath;

  Future<void> _pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      String imagePath = result.files.single.path!;
      setState(() {
        _lastSelectedImagePath = imagePath;
      });
      // ignore: use_build_context_synchronously
      await Navigator.pushNamed(context, '/showimage', arguments: imagePath);
    }
  }

  void _openLastSelectedImage(BuildContext context) async {
    if (_lastSelectedImagePath != null) {
      await Navigator.pushNamed(context, '/showimage',
          arguments: _lastSelectedImagePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image was previously selected!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          "assets/map3.jpg",
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.7),
          colorBlendMode: BlendMode.darken,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.5,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: screenHeight * 0.15,
                      color: Colors.blue,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    const Text(
                      "Drag and drop Files Here to upload",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(context);
                      },
                      child: Text("Select file to upload"),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        _openLastSelectedImage(context);
                      },
                      child: Text("Open last selected image"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
