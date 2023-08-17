import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/pages/bottom_nav_bar/bottom_navbar_view.dart';
import 'package:gathr_app/pages/welcome.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper/helper_functions.dart';

void main() async {
// Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // User logged in status
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus(); // is user already logged in
  }

  // Get user logged in status function
  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.red.shade400,
            onPrimary: Colors.white, // Text on primary color
            background: Colors.white,
            onSecondary: Colors.white,
            error: Colors.red,
            onBackground: Colors.white,
            onError: Colors.red.shade400,
            onSurface: Colors.black, // colors for text fields
            secondary: Colors.white,
            surface: Colors.grey.shade200, // colors for widgets
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: Colors.red.shade400,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? BottomNavBarView() : WelcomePage());
  }
}
