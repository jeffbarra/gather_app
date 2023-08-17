import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/data_controller.dart';
import '../widgets/events_feed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = AuthController();
  DataController dataController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
// AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            size: 30,
          ),
          onPressed: () {},
        ),
        actions: [
          // Alert/Notification Icon
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
              onPressed: () {},
            ),
          )
        ],
        title: Text('gather',
            style: GoogleFonts.modak(
              fontSize: 40,
            )),
      ),

// Body
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // // Header
              // const Text(
              //   "Events to Join",
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              // ),
              SizedBox(
                height: 10,
              ),
              // All Events
              eventsFeed(),
              Obx(
                () => dataController.isUsersLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    // "All Caught Up" Text
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                child: const Text('👍',
                                    style: TextStyle(fontSize: 30))),
                            const Text(
                              'You\'re all caught up!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
