import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/pages/auth/login.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';

class ResetViaEmail extends StatefulWidget {
  const ResetViaEmail({super.key});

  @override
  State<ResetViaEmail> createState() => _ResetViaEmailState();
}

class _ResetViaEmailState extends State<ResetViaEmail> {
// Email Controller
  final _emailController = TextEditingController();

// Memory management
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

// Password Reset Button Method
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // successful email sent message
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'Email Sent!',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            // confirmation message box
            content: const Text(
              'Check your email for a link to reset your password.',
              textAlign: TextAlign.center,
            ),
            // back to login button
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        Get.to(
                          () => const LoginPage(),
                        );
                      },
                      child: const Text('Back to Login')),
                ),
              ),
            ],
          );
        },
      );
      // error handler
    } on FirebaseAuthException catch (e) {
      print(e);
      // No email found error
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              'Oops!',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'No user found with that email address.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Reset Password',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Image(
                image: AssetImage(
                  'lib/assets/images/email_otp.png',
                ),
                width: 300,
              ),
            ),

// Instructions
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                'Enter your email address and we will send you a link to reset your password.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

// Form Field
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      hintText: "Enter Email",
                      prefixIcon: Icon(Icons.mail,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

// Submit Button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        passwordReset();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
