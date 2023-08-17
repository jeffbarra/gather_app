import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:gathr_app/pages/ask_to_join_page.dart';
import 'package:gathr_app/pages/check_out_page.dart';
import 'package:gathr_app/pages/invite_guest_page.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import '../utils/app_colors.dart';
import 'auth/login.dart';

class EventPageView extends StatefulWidget {
  DocumentSnapshot eventData, user;

  EventPageView(this.eventData, this.user);

  @override
  _EventPageViewState createState() => _EventPageViewState();
}

class _EventPageViewState extends State<EventPageView> {
// Auth Controller
  AuthController authController = AuthController();

// Data Controller
  DataController dataController = Get.put(DataController());

  List eventSavedByUsers = [];

  @override
  Widget build(BuildContext context) {
    String image = '';

    try {
      image = widget.user.get('image');
    } catch (e) {
      image = '';
    }

// Event Image
    String eventImage = '';
    try {
      List media = widget.eventData.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }

// Joined Users
    List joinedUsers = [];

    try {
      joinedUsers = widget.eventData.get('joined');
    } catch (e) {
      joinedUsers = [];
    }

// Tags
    List tags = [];
    try {
      tags = widget.eventData.get('tags');
    } catch (e) {
      tags = [];
    }
    // How tags will be displayed
    String displayTags = '';

    tags.forEach((e) {
      displayTags += '#$e ';
    });

    int likes = 0;
    int comments = 0;

// Likes
    try {
      likes = widget.eventData.get('likes').length;
    } catch (e) {
      likes = 0;
    }

// Comments
    try {
      comments = widget.eventData.get('comments').length;
    } catch (e) {
      comments = 0;
    }

// Events Saved by Users
    try {
      eventSavedByUsers = widget.eventData.get('saves');
    } catch (e) {
      eventSavedByUsers = [];
    }

    // DateTime? d = DateTime.tryParse(widget.eventData.get('date'));

    // String formattedDate = formatDate(widget.eventData.get('date'));
    // DateFormat("MM-dd-yyyy").format(d!);

    return Scaffold(
// App Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              size: 30,
            ),
            onPressed: () async {
              await authController.signOut();
              Get.to(() => const LoginPage());
            },
          )
        ],
        title: const Text(
          'Event Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

// Body
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      image,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.user.get('firstName')} ${widget.user.get('lastName')}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${widget.user.get('location')}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                        // if public -> green, if private -> red
                        color: widget.eventData.get('event') == "Public"
                            ? Colors.green.shade400.withOpacity(0.4)
                            : Colors.red.shade400.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Text(
                          '${widget.eventData.get('event')}', // "event type"
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(color: Colors.red.shade400, width: 1.5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      '${widget.eventData.get('start_time')}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.eventData.get('event_name')}",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.eventData.get('date')}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red.shade400),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${widget.eventData.get('location')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 3)),
                  ],
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(eventImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
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
                            margin: const EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              minRadius: 13,
                              backgroundImage: NetworkImage(image),
                            ),
                          );
                        },
                        itemCount: joinedUsers.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // price of event
                        Text(
                          '\$' + widget.eventData.get('price'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${widget.eventData.get('max_entries')} spots left!",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: widget.eventData.get('description'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ])),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      displayTags,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // if "public" -> invite button, if "private" -> alert box
                      onTap: () {
                        widget.eventData.get('event') == "Public"
                            ? Get.to(() => InviteGuests())
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Yikes!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'You are not allowed to invite others to a private event!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: widget.eventData.get('event') == "Public"
                                ? Theme.of(context).primaryColor
                                : Colors.grey),
                        child: const Center(
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.eventData!.get('event') == "Public"
                            ? Get.off(() => CheckOutPage(widget.eventData),
                                transition: Transition.noTransition,
                                duration: const Duration(milliseconds: 300))
                            : Get.off(() => const AskToJoinPage(),
                                transition: Transition.noTransition,
                                duration: const Duration(milliseconds: 300));
                      },
                      child: Container(
                        height: 50,
                        // if "public" -> white, if "private" -> red theme
                        decoration: BoxDecoration(
                            color: widget.eventData.get('event') == "Public"
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0.1,
                                blurRadius: 60,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Center(
                          // if public -> "join", if "private" -> "ask to join"
                          child: widget.eventData.get('event') == "Public"
                              ? const Text(
                                  'Join',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : const Text('Ask to Join',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_rounded,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      likes.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message_rounded)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      comments.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.send_rounded)),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (eventSavedByUsers
                            .contains(FirebaseAuth.instance.currentUser!.uid)) {
                          FirebaseFirestore.instance
                              .collection('events')
                              .doc(widget.eventData.id)
                              .set({
                            'saves': FieldValue.arrayRemove(
                                [FirebaseAuth.instance.currentUser!.uid])
                          }, SetOptions(merge: true));

                          eventSavedByUsers
                              .remove(FirebaseAuth.instance.currentUser!.uid);
                          setState(() {});
                        } else {
                          FirebaseFirestore.instance
                              .collection('events')
                              .doc(widget.eventData.id)
                              .set({
                            'saves': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid])
                          }, SetOptions(merge: true));
                          eventSavedByUsers
                              .add(FirebaseAuth.instance.currentUser!.uid);
                          setState(() {});
                        }
                      },
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border_rounded,
                          color: eventSavedByUsers.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
