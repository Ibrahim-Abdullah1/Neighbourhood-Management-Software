import "package:flutter/material.dart";
import "package:neighborhood_management_software/Screens/displayimage.dart";
import "package:neighborhood_management_software/Screens/imagedisplayscreen.dart";
import "package:neighborhood_management_software/Screens/signin.dart";
import "package:neighborhood_management_software/Screens/uploadimage.dart";

void main() {
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
