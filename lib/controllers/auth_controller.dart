import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gathr_app/pages/bottom_nav_bar/bottom_navbar_view.dart';
import 'package:get/get.dart';
import '../helper/helper_functions.dart';
import '../services/database_service.dart';
import 'package:path/path.dart' as Path;

class AuthController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// Login Function

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// Register Function

  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data
        await DataBaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
      // error exceptions
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// Sign Out Function

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

// isProfileInformationLoading

  var isProfileInformationLoading = false.obs;

// Upload Image to Storage

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print(e.message);
    });

    return imageUrl;
  }

// Upload Profile Data
  uploadProfileData(String imageUrl, String firstName, String lastName,
      String phoneNumber, String dob) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('profiles').doc(uid).set({
      'image': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(() => BottomNavBarView());
    });
  }
}
