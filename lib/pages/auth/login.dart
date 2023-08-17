import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:gathr_app/pages/auth/register.dart';
import 'package:gathr_app/pages/bottom_nav_bar/bottom_navbar_view.dart';
import 'package:get/get.dart';
import '../../helper/helper_functions.dart';
import '../../services/database_service.dart';
import '../../widgets/forgot_password_footer.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
// Show Password Toggle
  bool _passwordVisible = false;

// isLoading
  bool _isLoading = false;

  // formKey
  final formKey = GlobalKey<FormState>();

// Text fields -> onChange
  String email = '';
  String password = '';

// Auth Service
  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
// Image
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // image
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Image(
                              image: AssetImage('lib/assets/images/login.png'),
                              width: 350,
                            ),
                          ),
                        ],
                      ),

// Welcome Back
                      Center(
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

// Login Text
                      const Center(
                        child: Text(
                          'Login in now to view your events.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

// Login Form
                      Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // email field
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                      labelText: "Email",
                                      hintText: "Enter Email",
                                      prefixIcon: Icon(Icons.mail,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    // reading text inside email field
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          email = value;
                                        },
                                      );
                                    },
                                    // email validation
                                    validator: (val) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val!)
                                          ? null
                                          : "Please enter a valid email";
                                    },
                                  ),

                                  const SizedBox(height: 10),

// Password Field
                                  TextFormField(
                                    obscureText: !_passwordVisible,
                                    decoration: textInputDecoration.copyWith(
                                      labelText: "Password",
                                      hintText: "Enter Password",
                                      prefixIcon: Icon(Icons.lock,
                                          color:
                                              Theme.of(context).primaryColor),
                                      // hide and show password icon
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color:
                                                Theme.of(context).primaryColor),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    // reading text inside password field
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          password = value;
                                        },
                                      );
                                    },
                                    // check validation
                                    validator: (val) {
                                      if (val!.length < 6) {
                                        return "Password must be at least 6 characters";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),

// Forgot Password? Footer Link
                                  const ForgotPasswordFooter(),

// Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        login();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text('Login',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

// Or Login with Google
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // google button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black)),
                              icon: const Image(
                                image: AssetImage(
                                  'lib/assets/images/google_logo.png',
                                ),
                                width: 30,
                              ),
                              onPressed: () {},
                              label: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Sign-in with Google',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

// Don't Have an Account?
                          TextButton(
                            onPressed: () {
                              // go to register page
                              Get.to(
                                const RegisterPage(),
                                transition: Transition.leftToRight,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                  text: "Don\'t have an account? ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

// Login Function
  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authController.loginUserWithEmailAndPassword(email, password).then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot = await DataBaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
            // saving the values to our shared preferences
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
            Get.to(
              BottomNavBarView(),
              transition: Transition.noTransition,
              duration: const Duration(milliseconds: 100),
            );
          } else {
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    }
  }
}
