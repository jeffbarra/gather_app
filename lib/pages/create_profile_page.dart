import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/widgets.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
// Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

// Date Picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dob.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

// Text Controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dob = TextEditingController();

// Image Picker
  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text('Upload Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor))),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.photo_library_rounded,
                  size: 40,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Profile Pic File Image
  File? profileImage;

// Auth Controller
  AuthController? authController;

// Init State
  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
                InkWell(
                  onTap: () {
                    imagePickDialog();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.all(2),
                    // avatar circular border
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(70),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7DDCFB),
                          Color(0xffBC67F2),
                          Color(0xffACF6AF),
                          Color(0xffF95549),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: profileImage == null
                              ? const CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  backgroundImage: FileImage(
                                    profileImage!,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width * 0.1,
                ),

// First Name Text Field
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "First Name",
                    hintText: "Enter First Name",
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        firstNameController.text = val;
                      },
                    );
                  },
// First Name Validation
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "First name is required";
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

// Last Name Text Field
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Last Name",
                    hintText: "Enter Last Name",
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        lastNameController.text = val;
                      },
                    );
                  },
// Last Name Validation
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Last name is required";
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

// Phone Number Field
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Phone Number",
                    hintText: "Enter Phone Number",
                    prefixIcon: Icon(Icons.phone,
                        color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        phoneNumberController.text = val;
                      },
                    );
                  },
// Phone Number Validation
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Phone number is required";
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

// Date of Birth Field
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      dob.text = val;
                    });
                  },
                  controller: dob,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Date of Birth',
                    hintText: "Enter Your Date of Birth",
                    prefixIcon: Icon(Icons.event,
                        color: Theme.of(context).primaryColor),
                  ),
                  onTap: () async {
                    _selectDate(context);
                  },
                ),

// Circular Progress Indicator OR Elevated Button
                Obx(() => authController!.isProfileInformationLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 50,
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        width: Get.width,
                        child: ElevatedButton(
                          child: Text('Save'),
                          onPressed: () async {
                            if (dob.text.isEmpty) {
                              Get.snackbar('Oops!', "Missing required fields!",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return;
                            }

                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            if (profileImage == null) {
                              Get.snackbar('Yikes!', "Image is required!",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return;
                            }

                            authController!.isProfileInformationLoading(true);

                            String imageUrl = await authController!
                                .uploadImageToFirebaseStorage(profileImage!);

                            authController!.uploadProfileData(
                                imageUrl,
                                firstNameController.text.trim(),
                                lastNameController.text.trim(),
                                phoneNumberController.text.trim(),
                                dob.text.trim());
                          },
                        ),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                    width: Get.width * 0.8,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'By signing up, you agree our ',
                            style: TextStyle(
                                color: Color(0xff262628), fontSize: 12)),
                        TextSpan(
                            text: 'terms, data policy and cookies policy',
                            style: TextStyle(
                                color: Color(0xff262628),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
