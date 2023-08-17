import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/pages/event_page_view.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import '../utils/app_colors.dart';

Widget // eventsJoined
    eventsJoined() {
  DataController dataController = Get.put(DataController());

  DocumentSnapshot myUser = dataController.allUsers
      .firstWhere((e) => e.id == FirebaseAuth.instance.currentUser!.uid);

  String userImage = '';
  String userName = '';

  try {
    userImage = myUser.get('image');
  } catch (e) {
    userImage = '';
  }

  try {
    userName = '${myUser.get('firstName')} ${myUser.get('lastName')}';
  } catch (e) {
    userName = '';
  }

  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.01,
      ),

// Bottom Section - Events I Have Joined
      Expanded(
        child: Container(
          child: Obx(
            () => dataController.isEventsLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: dataController.joinedEvents.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      String name =
                          dataController.joinedEvents[i].get('event_name');

                      String date = dataController.joinedEvents[i].get('date');

                      date = date.split('-')[0] + '-' + date.split('-')[1];

                      List joinedUsers = [];

                      try {
                        joinedUsers =
                            dataController.joinedEvents[i].get('joined');
                      } catch (e) {
                        joinedUsers = [];
                      }

                      // Event Tile
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Get User Information as "doc"
                            String eventUserId = '';
                            eventUserId = dataController.filteredEvents.value[i]
                                .get('uid');
                            DocumentSnapshot doc = dataController.allUsers
                                .firstWhere(
                                    (element) => element.id == eventUserId);
                            try {
                              userName = doc.get('first');
                            } catch (e) {
                              userName = '';
                            }
                            // Go to EventPageView for filtered event (selected event)
                            Get.to(
                                () => EventPageView(
                                    dataController.filteredEvents.value[i],
                                    doc),
                                transition: Transition.noTransition,
                                duration: Duration(milliseconds: 300));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      // Tiny date box
                                      Container(
                                        width: 35, height: 35,
                                        alignment: Alignment.center,
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: 10, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            // tiny date tile
                                            color: Colors.green.shade100,
                                          ),
                                        ),
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.06,
                                      ),
                                      // Name of Event
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Guest List Avatars
                                Container(
                                    width: Get.width * 0.6,
                                    height: 50,
                                    child: ListView.builder(
                                      itemBuilder: (ctx, index) {
                                        DocumentSnapshot user = dataController
                                            .allUsers
                                            .firstWhere((e) =>
                                                e.id == joinedUsers[index]);

                                        String image = '';

                                        try {
                                          image = user.get('image');
                                        } catch (e) {
                                          image = '';
                                        }

                                        return Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: CircleAvatar(
                                            minRadius: 13,
                                            backgroundImage:
                                                NetworkImage(image),
                                          ),
                                        );
                                      },
                                      itemCount: joinedUsers.length,
                                      scrollDirection: Axis.horizontal,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    ],
  );
}
