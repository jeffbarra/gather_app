import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/pages/event_page_view.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/data_controller.dart';
import '../widgets/widgets.dart';
import 'auth/login.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // Auth Controller
  AuthController authController = AuthController();

  TextEditingController searchController = TextEditingController();
  DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// App Bar
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
          'Community',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: Get.height,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (String input) {
                      if (input.isEmpty) {
                        dataController.filteredEvents
                            .assignAll(dataController.allEvents);
                      } else {
                        List<DocumentSnapshot> data =
                            dataController.allEvents.value.where((element) {
                          List tags = [];

                          bool isTagContain = false;

                          try {
                            tags = element.get('tags');
                            for (int i = 0; i < tags.length; i++) {
                              tags[i] = tags[i].toString().toLowerCase();
                              if (tags[i].toString().contains(
                                  searchController.text.toLowerCase())) {
                                isTagContain = true;
                              }
                            }
                          } catch (e) {
                            tags = [];
                          }
                          return (element
                                  .get('location')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()) ||
                              isTagContain ||
                              element
                                  .get('event_name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()));
                        }).toList();
                        dataController.filteredEvents.assignAll(data);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(15),
                        child: const Icon(Icons.search_rounded),
                      ),
                      hintText: 'Search for an event...',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 30,
                            childAspectRatio: 0.93),
                    shrinkWrap: true,
                    itemCount: dataController.filteredEvents.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      String userName = '',
                          userImage = '',
                          eventUserId = '',
                          location = '',
                          eventImage = '',
                          tagString = '';
                      eventUserId =
                          dataController.filteredEvents.value[i].get('uid');
                      DocumentSnapshot doc = dataController.allUsers
                          .firstWhere((element) => element.id == eventUserId);

                      try {
                        userName = doc.get('first');
                      } catch (e) {
                        userName = '';
                      }

                      try {
                        userImage = doc.get('image');
                      } catch (e) {
                        userImage = '';
                      }

                      try {
                        location = dataController.filteredEvents.value[i]
                            .get('location');
                      } catch (e) {
                        location = '';
                      }

                      try {
                        List media =
                            dataController.filteredEvents.value[i].get('media');

                        eventImage = media.firstWhere(
                            (element) => element['isImage'] == true)['url'];
                      } catch (e) {
                        eventImage = '';
                      }

                      List tags = [];

                      try {
                        tags =
                            dataController.filteredEvents.value[i].get('tags');
                      } catch (e) {
                        tags = [];
                      }

                      if (tags.length == 0) {
                        tagString = dataController.filteredEvents.value[i]
                            .get('description');
                      } else {
                        tags.forEach((element) {
                          tagString += "#$element, ";
                        });
                      }

                      String eventName = '';
                      try {
                        eventName = dataController.filteredEvents.value[i]
                            .get('event_name');
                      } catch (e) {
                        eventName = '';
                      }

                      return InkWell(
                        onTap: () {
                          // Get User Information as "doc"
                          String eventUserId = '';
                          eventUserId =
                              dataController.filteredEvents.value[i].get('uid');
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
                                  dataController.filteredEvents.value[i], doc),
                              transition: Transition.noTransition,
                              duration: Duration(milliseconds: 300));
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  eventImage,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              myText(
                                text: eventName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
