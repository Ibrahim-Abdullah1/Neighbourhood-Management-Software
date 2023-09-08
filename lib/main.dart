import "dart:io";
import "dart:ui";
import "package:flutter/material.dart";
import 'package:neighborhood_management_software/Providers/pinDataProvider.dart';
import "package:neighborhood_management_software/Screens/imagedisplayscreen.dart";
import "package:neighborhood_management_software/Screens/signin.dart";
import "package:neighborhood_management_software/Screens/uploadimage.dart";
import "package:provider/provider.dart";
import "package:window_size/window_size.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    var pixelRatio = window.devicePixelRatio;
    var physicalScreenSize = window.physicalSize;
    var logicalScreenSize = physicalScreenSize / pixelRatio;

    setWindowMaxSize(logicalScreenSize);
    setWindowMinSize(logicalScreenSize);

    Future<Null>.delayed(Duration(seconds: 1), () {
      setWindowFrame(Rect.fromLTWH(
          0, 0, logicalScreenSize.width, logicalScreenSize.height));
    });
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => PinDataNotifier(),
      child: MyApp(),
    ),
  );
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
