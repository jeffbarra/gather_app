import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:gathr_app/pages/create_profile_page.dart';
import 'package:get/get.dart';
import '../../helper/helper_functions.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
// Show Password Toggle
  bool _passwordVisible = false;

// isLoading
  bool _isLoading = false;

// Form Key
  final formKey = GlobalKey<FormState>();

// Text fields -> onChange
  String fullName = "";
  String email = "";
  String password = "";

// Auth Controller
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
                              image:
                                  AssetImage('lib/assets/images/register.png'),
                              width: 350,
                            ),
                          ),
                        ],
                      ),

// Join Today
                      Center(
                        child: Text(
                          'Join Today!',
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

// Create Account Text
                      const Center(
                        child: Text(
                          'Create an account to get started.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

// Register Form
                      Form(
                        key: formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
// Full Name Field
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Full Name",
                                  hintText: "Enter Full Name",
                                  prefixIcon: Icon(Icons.person,
                                      color: Theme.of(context).primaryColor),
                                ),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      fullName = val;
                                    },
                                  );
                                },
// Full Name Validation
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Name is required";
                                  }
                                },
                              ),

                              const SizedBox(height: 10),

// Email field
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  hintText: "Enter Email",
                                  prefixIcon: Icon(Icons.mail,
                                      color: Theme.of(context).primaryColor),
                                ),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      email = val;
                                    },
                                  );
                                },
// Email Validation
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
                                      color: Theme.of(context).primaryColor),
                                  // hide and show password icon
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      setState(
                                        () {
                                          _passwordVisible = !_passwordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
// Password Validation
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                              const SizedBox(height: 30),

// Sign Up Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    register();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Sign Up',
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

// Login with Google
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
                                  'Sign up with Google',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

// Already Have an Account?
                          TextButton(
                            onPressed: () {
// Go to Login Page
                              Get.to(const LoginPage(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 300));
                            },
                            child: Text.rich(
                              TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Login",
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

// Register Function
  register() async {
    if (formKey.currentState!.validate()) {
      setState(
        () {
          _isLoading = true;
        },
      );
      await authController
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then(
        (value) async {
          if (value == true) {
            // saving the shared preferences state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(fullName);
            // go to CreateProfilePage()
            Get.to(
              CreateProfilePage(),
              transition: Transition.noTransition,
              duration: const Duration(milliseconds: 100),
            );
          } else {
            showSnackBar(context, Colors.red, value);
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
      );
    }
  }
}
