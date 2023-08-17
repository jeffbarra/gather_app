import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import '../pages/event_page_view.dart';
import '../utils/app_colors.dart';

Widget eventsFeed() {
  DataController dataController = Get.put(DataController());

  return Obx(() => dataController.isEventsLoading.value
      ? Center(
          child: CircularProgressIndicator(color: Colors.red.shade400),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            // Return all events formatted as eventItem
            return eventItem(dataController.allEvents[i]);
          },
          itemCount: dataController.allEvents.length,
        ));
}

Widget buildCard(
    {String? image, text, Function? func, DocumentSnapshot? eventData}) {
  DataController dataController = Get.put(DataController());

  List joinedUsers = [];

  try {
    // fetching events that current user is "joined"
    joinedUsers = eventData!.get('joined');
  } catch (e) {
    joinedUsers = [];
  }

// 'date' field from specific event is being saved as dateInformation
  List dateInformation = [];
  try {
    dateInformation = eventData!.get('date').toString().split('-');
  } catch (e) {
    dateInformation = [];
  }

  int comments = 0;

  List userLikes = [];

  try {
    userLikes = eventData!.get('likes');
  } catch (e) {
    userLikes = [];
  }

  try {
    comments = eventData!.get('comments').length;
  } catch (e) {
    comments = 0;
  }

  List eventSavedByUsers = [];
  try {
    eventSavedByUsers = eventData!.get('saves');
  } catch (e) {
    eventSavedByUsers = [];
  }

// Main Event Tile
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      // shadow
    ),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            func!();
          },
          // Event photo
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 3)),
              ],
              image: DecorationImage(
                  image: NetworkImage(image!), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30),
            ),
            width: double.infinity,
            height: Get.width * 0.5,
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // Tiny Date Tile
        Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 41,
                  height: 24,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade400)),
                  // Date of event within tiny tile
                  child: Text(
                    '${dateInformation[1]}-${dateInformation[0]}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),

                // Name of Event
                Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black),
                ),
                // spacer for bookmark icon
                const Spacer(),
                // "Bookmark" Icon Functionality ???
                InkWell(
                  onTap: () {
                    if (eventSavedByUsers
                        .contains(FirebaseAuth.instance.currentUser!.uid)) {
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(eventData!.id)
                          .set({
                        'saves': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser!.uid])
                      }, SetOptions(merge: true));
                    } else {
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(eventData!.id)
                          .set({
                        'saves': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser!.uid])
                      }, SetOptions(merge: true));
                    }
                  },
                  // "Bookmark" Icon
                  child: Container(
                    child: Icon(
                      Icons.bookmark_border,
                      size: 30,
                      color: eventSavedByUsers
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red.shade400
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Event Guests Avatar Images
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Container(
                  width: Get.width * 0.6,
                  height: 50,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot user = dataController.allUsers
                          .firstWhere((e) => e.id == joinedUsers[index]);

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
                          backgroundImage: NetworkImage(image),
                        ),
                      );
                    },
                    itemCount: joinedUsers.length,
                    scrollDirection: Axis.horizontal,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),

        // Fetching "likes"
        Row(
          children: [
            InkWell(
              onTap: () {
                if (userLikes
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                } else {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                }
              },
              // Likes, comments, send icon area
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // like button
                    Icon(
                      Icons.favorite_rounded,
                      size: 25,
                      color: userLikes
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red.shade400
                          : Colors.black,
                    ),

                    const SizedBox(width: 15),

                    // # of likes
                    Text(
                      '${userLikes.length}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 15),

                    // comments button
                    const Icon(Icons.message_rounded, size: 25),

                    const SizedBox(width: 15),

                    // # of comments
                    Text(
                      '$comments',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(width: 15),

                    // send button
                    const Icon(Icons.send_rounded, size: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// eventItem -> Snapshot of event as eventItem
eventItem(DocumentSnapshot event) {
  DataController dataController = Get.put(DataController());

  DocumentSnapshot user =
      dataController.allUsers.firstWhere((e) => event.get('uid') == e.id);

  String image = '';

  try {
    image = user.get('image');
  } catch (e) {
    image = '';
  }

  String eventImage = '';
  try {
    List media = event.get('media') as List;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    eventImage = mediaItem['url'];
  } catch (e) {
    eventImage = '';
  }

// Current User Name and Avatar - TOP
  return Column(
    children: [
// buildCard (used up top)
      buildCard(
          image: eventImage,
          text: event.get('event_name'),
          eventData: event,
          func: () {
            Get.to(() => EventPageView(event, user),
                transition: Transition.noTransition,
                duration: Duration(milliseconds: 300));
          }),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}
