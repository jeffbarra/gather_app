import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

// Reference For Collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // final CollectionReference eventCollection =
  //     FirebaseFirestore.instance.collection('events');

// Saving User Data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
    });
  }

// Getting User Data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
