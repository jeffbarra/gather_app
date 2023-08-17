import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/registered_events.dart';
import '../controllers/data_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/events_joined.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// Text Editing Controllers
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

// Editable Text for Profile Info
  bool isNotEditable = true;

// Data Controller
  late DataController? dataController;

  int? followers = 0, following = 0;
  String? image = '';

// Init State
  @override
  initState() {
    super.initState();
    // init data controller
    dataController = Get.put(DataController());

    // fetch data from myDocument from Data Controller
    firstNameController.text =
        dataController!.myDocument?.get('firstName') ?? "";
    lastNameController.text = dataController!.myDocument?.get('lastName') ?? "";

    try {
      descriptionController.text = dataController!.myDocument!.get('desc');
    } catch (e) {
      descriptionController.text = '';
    }

    try {
      image = dataController!.myDocument!.get('image');
    } catch (e) {
      image = '';
    }

    try {
      locationController.text = dataController!.myDocument!.get('location');
    } catch (e) {
      locationController.text = '';
    }

    try {
      followers = dataController!.myDocument!.get('followers').length;
    } catch (e) {
      followers = 0;
    }

    try {
      following = dataController!.myDocument!.get('following').length;
    } catch (e) {
      following = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
// Media Query
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
// AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, size: 30),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sms_rounded, size: 30),
            ),
          )
        ],
      ),

// Body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(
                      left: Get.width * 0.75, top: 20, right: 20),
                  alignment: Alignment.topRight,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ),

// White Shadowed Profile Container
              Align(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 90, horizontal: 20),
                  width: Get.width,
                  height: isNotEditable ? 240 : 310,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),

// Circular Profile Avatar Section
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      // Colored Avatar Border
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(top: 35),
                        padding: const EdgeInsets.all(2),
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
                            // Avatar
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: image!.isEmpty
                                  ? const CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        'lib/assets/images/avatar.png',
                                      ))
                                  : CircleAvatar(
                                      radius: 56,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        image!,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

// First Name Field & Controller
                    isNotEditable
                        ? Text(
                            "${firstNameController.text} ${lastNameController.text}",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: firstNameController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'First Name',
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

// Last Name Field & Controller
                                Expanded(
                                  child: TextField(
                                    controller: lastNameController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Last Name',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

// Location Field & Controller
                    isNotEditable
                        ? Text(
                            locationController.text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff918F8F),
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: TextField(
                              controller: locationController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Location',
                              ),
                            ),
                          ),

                    const SizedBox(
                      height: 10,
                    ),

// Description Field & Controller
                    isNotEditable
                        ? Container(
                            width: 270,
                            child: Text(
                              descriptionController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: TextField(
                              controller: descriptionController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Description',
                              ),
                            ),
                          ),

                    const SizedBox(
                      height: 25,
                    ),

// Followers
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "$followers",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "Followers",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),

// Following
                          Container(
                            width: 1,
                            height: 35,
                            color: const Color(0xff918F8F).withOpacity(0.5),
                          ),
                          Column(
                            children: [
                              // Number of followers
                              Text(
                                "$following",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Following",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),

// Text Button
                          Container(
                            height: 40,
                            width: screenwidth * 0.25,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              onPressed: () {},
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
// Add Circle
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 53,
                                height: 53,
                                child: const Icon(Icons.add_circle_rounded,
                                    size: 50, color: Colors.grey)),

// Test User Avatar
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Colors.white,
                              ),
                              child: const Image(
                                image: AssetImage(
                                    'lib/assets/images/test_user_1.png'),
                              ),
                            ),

// Test User Avatar
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Colors.white,
                              ),
                              child: const Image(
                                image: AssetImage(
                                    'lib/assets/images/test_user_2.png'),
                              ),
                            ),

// Test User Avatar
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Colors.white,
                              ),
                              child: const Image(
                                image: AssetImage(
                                    'lib/assets/images/test_user_3.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
// Tab Controller
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultTabController(
                        animationDuration: Duration.zero,
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(),
                              // Tab Bar
                              child: TabBar(
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                indicatorColor: Theme.of(context).primaryColor,
                                labelPadding: const EdgeInsets.only(top: 20.0),
                                unselectedLabelColor: Colors.grey,
                                labelColor: Theme.of(context).primaryColor,

                                // Tab #1 - Joined
                                tabs: const [
                                  Tab(
                                    text: 'Joined',
                                  ),

                                  // Tab #2 - Joined
                                  Tab(text: 'Hosted'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: screenheight * 0.46,
                              //height of TabBarView
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              // Tab Bar View
                              child: TabBarView(
                                children: <Widget>[
                                  // Tab 1
                                  // list of registered events
                                  eventsJoined(),

                                  Container(
                                    child: const Center(
                                      child: Text('Tab 2',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Edited values get saved to firebase
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 105, right: 35),
                  child: InkWell(
                    onTap: () {
                      if (isNotEditable == false) {
                        FirebaseFirestore.instance
                            .collection('profiles')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'firstName': firstNameController.text,
                          'lastName': lastNameController.text,
                          'location': locationController.text,
                          'desc': descriptionController.text
                        }, SetOptions(merge: true)).then((value) {
                          Get.snackbar('Profile Updated',
                              'Profile has been updated successfully!',
                              colorText: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor);
                        });
                      }

                      setState(() {
                        isNotEditable = !isNotEditable;
                      });
                    },
                    child: isNotEditable
                        ? Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          )
                        : Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
