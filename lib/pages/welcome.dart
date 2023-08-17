import 'package:flutter/material.dart';
import 'package:gathr_app/pages/auth/register.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
// Height based on device
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
// Logo & Slogan
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'gather',
                      style: GoogleFonts.modak(
                          fontSize: 60, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),

// Welcome Image
              const Column(
                children: [
                  // Welcome Image
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Image(
                      image: AssetImage('lib/assets/images/welcome.png'),
                    ),
                  ),
                ],
              ),

// Slogan
              Column(
                children: [
                  Text(
                    'Create Fun!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 10),

// Description
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                    child: Text(
                      'Creating groups, events & gatherings has never been easier!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

// Sign Up Button
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                      child: ElevatedButton(
                        // go to register page
                        onPressed: () {
                          Get.to(const RegisterPage(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 300));
                        },
                        style: ElevatedButton.styleFrom(
                            // shape: RoundedRectangleBorder(),
                            backgroundColor: Theme.of(context).primaryColor),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('Get Started',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
