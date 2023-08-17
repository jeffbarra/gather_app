import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../community_page.dart';
import '../create_event_page.dart';
import '../home_page.dart';
import '../message_page.dart';
import '../profile_page.dart';

class BottomNavBarView extends StatefulWidget {
  BottomNavBarView({Key? key}) : super(key: key);

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  int currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> widgetOption = [
    HomePage(),
    CommunityPage(),
    CreateEventPage(),
    ChatPage(),
    ProfilePage()
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Get.put(DataController(), permanent: true);
  //   FirebaseMessaging.instance.getInitialMessage();
  //   FirebaseMessaging.onMessage.listen((message) {
  //     LocalNotificationService.display(message);
  //   });

  //   LocalNotificationService.storeToken();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
// Bottom Nav Bar
          child: BottomNavigationBar(
            onTap: onItemTapped,
            currentIndex: currentIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).primaryColor,
            type: BottomNavigationBarType.fixed,
            items: [
              // Home Icon
              const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.home_rounded,
                      size: 35,
                    ),
                  ),
                  label: ''),

              // Community Icon
              const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.people_alt,
                      size: 35,
                    ),
                  ),
                  label: ''),

              // Add Event Icon
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () {
                          Get.to(() => CreateEventPage(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 300));
                        },
                        color: Theme.of(context).primaryColor,
                        iconSize: 60,
                      )),
                  label: ''),

              // Chat Icon
              const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.chat_rounded,
                      size: 35,
                    ),
                  ),
                  label: ''),

              // Profile Icon
              const BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.account_circle, size: 35)),
                  label: ''),
            ],
          ),
        ),

// Body
        body: widgetOption[currentIndex]);
  }
}
