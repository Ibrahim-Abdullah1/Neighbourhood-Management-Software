import "dart:io";

import "package:flutter/material.dart";
import "package:neighborhood_management_software/Screens/displayimage.dart";
import "package:neighborhood_management_software/Screens/imagedisplayscreen.dart";
import "package:neighborhood_management_software/Screens/signin.dart";
import "package:neighborhood_management_software/Screens/uploadimage.dart";
import "package:window_size/window_size.dart";


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // We'll get the actual screen dimensions dynamically.
    // The following are placeholders till we get the actual values.
    double screenWidth = 1920; // placeholder
    double screenHeight = 1080; // placeholder

    // Set these values after fetching from native code.
    setWindowMaxSize(Size(screenWidth, screenHeight));
    setWindowMinSize(Size(screenWidth, screenHeight));

    Future.delayed(Duration(seconds: 1), () {
      setWindowFrame(Rect.fromCenter(
          center: Offset(screenWidth / 2, screenHeight / 2),
          width: screenWidth,
          height: screenHeight));
    });
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Neighborhood Management App",
      home: SignIn(),
      routes: {
        '/signin': (context) => SignIn(),
        '/uploadimage': (context) => UploadPage(),
        '/showimage': (context) => ShowImage(),
      },
    );
  }
}
