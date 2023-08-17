import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:gathr_app/pages/bottom_nav_bar/bottom_navbar_view.dart';
import 'package:gathr_app/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../controllers/data_controller.dart';
import '../model/event_media_model.dart';
import '../utils/app_colors.dart';
import '../widgets/widgets.dart';
import 'auth/login.dart';

class CreateEventPage extends StatefulWidget {
  CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
// Auth Controller
  AuthController authController = AuthController();

// DateTime = Today's Date
  DateTime? date = DateTime.now();

// Text Controllers
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController maxEntries = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController frequencyEventController = TextEditingController();

// Time of Day
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

// Selected Frequency
  var selectedFrequency = -2;

// Reset Controllers
  void resetControllers() {
    dateController.clear();
    timeController.clear();
    titleController.clear();
    locationController.clear();
    priceController.clear();
    descriptionController.clear();
    tagsController.clear();
    maxEntries.clear();
    endTimeController.clear();
    startTimeController.clear();
    frequencyEventController.clear();
    startTime = const TimeOfDay(hour: 0, minute: 0);
    endTime = const TimeOfDay(hour: 0, minute: 0);
    setState(() {});
  }

// isCreating Event => Circular Loading
  var isCreatingEvent = false.obs;

// Date Picker
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialDate: DateTime.now(),
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      dateController.text = '${date!.month}-${date!.day}-${date!.year}';
    }
    setState(() {});
  }

// Start Time Method
  startTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    print("start ${startTimeController.text}");
    setState(() {});
  }

// End Time Method
  endTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      endTimeController.text =
          '${endTime.hourOfPeriod > 9 ? "" : "0"}${endTime.hour > 9 ? "" : "0"}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour > 12 ? 'PM' : 'AM'}';
    }

    print(endTime.hourOfPeriod);
    setState(() {});
  }

// Event Type for Dropdown
  String eventType = 'Public';
  List<String> listItem = ['Public', 'Private'];

// Event Access ("Open" OR "Closed")
  String accessModifier = 'Closed';
  List<String> closeList = [
    'Closed',
    'Open',
  ];

// Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

// Media URLs
  List<Map<String, dynamic>> mediaUrls = [];

// Event Media Model
  List<EventMediaModel> media = [];

  // List<File> media = [];
  // List thumbnail = [];
  // List<bool> isImage = [];

// Init State
  @override
  void initState() {
    super.initState();
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// App Bar
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => BottomNavBarView);
                  resetControllers();
                },
              ),
            )
          ],
          title: const Text('Create Event',
              style: TextStyle(fontWeight: FontWeight.bold))),

// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  // Drop Down ("Public" OR "Private")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: 100,
                        height: 33,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30)),
                        // Drop Down Button
                        child: DropdownButton(
                          isExpanded: true,
                          underline: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     width: 0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              ),

                          // borderRadius: BorderRadius.circular(10),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          elevation: 16,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          value: eventType,
                          onChanged: (String? newValue) {
                            setState(
                              () {
                                eventType = newValue!;
                              },
                            );
                          },
                          items: listItem
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: Get.height * 0.03,
                  ),

                  // Dotted Upload Container
                  Container(
                    height: Get.width * 0.6,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                        color: AppColors.border.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: DottedBorder(
                      color: AppColors.border,
                      strokeWidth: 1.5,
                      dashPattern: [6, 6],
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            // Upload Icon
                            Container(
                              width: 76,
                              height: 59,
                              child: const Icon(Icons.upload, size: 30),
                            ),
                            // Upload Image/Video Header
                            myText(
                              text: 'Upload Image / Video',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Upload Button
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                // Choose media type dialog box
                                onPressed: () async {
                                  mediaDialog(context);
                                },
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // If empty
                  media.isEmpty
                      ? Container()
                      // If not empty
                      : const SizedBox(
                          height: 20,
                        ),
                  // If empty
                  media.isEmpty
                      ? Container()
                      // If not empty => Video upload
                      : Container(
                          width: Get.width,
                          height: Get.width * 0.3,
                          child: ListView.builder(
                              itemBuilder: (ctx, i) {
                                return media[i].isVideo!
                                    // !isImage[i]
                                    ? Container(
                                        // Video thumbnail
                                        width: Get.width * 0.3,
                                        height: Get.width * 0.3,
                                        margin: const EdgeInsets.only(
                                            right: 15, bottom: 10, top: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(
                                                  media[i].thumbnail!),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  // Delete image button
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors
                                                        .blue.shade400
                                                        .withOpacity(0.6),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        media.removeAt(i);
                                                        // media.removeAt(i);
                                                        // isImage.removeAt(i);
                                                        // thumbnail.removeAt(i);
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Align(
                                              alignment: Alignment.center,
                                              // Upload video icon
                                              child: Icon(
                                                Icons.slow_motion_video_rounded,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    // if Not empty => Image upload
                                    : Container(
                                        // Image Thumbnail
                                        width: Get.width * 0.3,
                                        height: Get.width * 0.3,
                                        margin: const EdgeInsets.only(
                                            right: 15, bottom: 10, top: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(media[i].image!),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: CircleAvatar(
                                                backgroundColor: Colors
                                                    .blue.shade400
                                                    .withOpacity(0.6),
                                                child: IconButton(
                                                  onPressed: () {
                                                    media.removeAt(i);
                                                    // isImage.removeAt(i);
                                                    // thumbnail.removeAt(i);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                              },
                              itemCount: media.length,
                              scrollDirection: Axis.horizontal),
                        ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Event Name Field
                  myTextField(
                      bool: false,
                      icon: const Icon(
                        Icons.event_note_rounded,
                      ),
                      text: 'Event Name',
                      controller: titleController,
                      validator: (String input) {
                        if (input.isEmpty) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event name is required!');
                          return '';
                        }

                        if (input.length < 3) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event name must be at least 3 characters!');

                          return '';
                        }
                        return null;
                      }),

                  const SizedBox(
                    height: 20,
                  ),

                  // Event Location Field
                  myTextField(
                      bool: false,
                      icon: const Icon(Icons.location_on_outlined),
                      text: 'Location',
                      controller: locationController,
                      validator: (String input) {
                        if (input.isEmpty) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event location is required!');
                          return '';
                        }

                        if (input.length < 3) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event location is invalid!');
                          return '';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
// Event Date
                  Row(
                    children: [
                      Expanded(
                        child: iconTitleContainer(
                          height: 45,
                          isReadOnly: true,
                          icon: const Icon(Icons.date_range_outlined),
                          text: 'Date',
                          controller: dateController,
                          validator: (input) {
                            if (date == null) {
                              showSnackBar(context, Colors.red.shade400,
                                  'Event date is required!');
                              return '';
                            }
                            return null;
                          },
                          onPress: () {
                            _selectDate(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 5),
// Max Entries
                      Expanded(
                        child: iconTitleContainer(
                            height: 45,
                            icon: const Icon(Icons.people_alt_outlined),
                            text: 'Max Entries',
                            controller: maxEntries,
                            type: TextInputType.number,
                            onPress: () {},
                            validator: (String input) {
                              if (input.isEmpty) {
                                showSnackBar(context, Colors.red.shade400,
                                    'Max entries is required!');
                                return '';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Icon Title Container from "Widgets"
                  iconTitleContainer(
                      icon: const Icon(Icons.tag),
                      text: 'Event tags',
                      height: 45,
                      width: double.infinity,
                      controller: tagsController,
                      type: TextInputType.text,
                      onPress: () {},
                      validator: (String input) {
                        if (input.isEmpty) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event tags are required!');
                          return '';
                        }
                        return null;
                      }),

                  const SizedBox(
                    height: 20,
                  ),

                  // Event Frequency
                  Container(
                    height: 45,
                    child: TextFormField(
                      readOnly: true,
                      // Event frequency bottom sheet
                      onTap: () {
                        Get.bottomSheet(StatefulBuilder(builder: (ctx, state) {
                          return Container(
                            width: double.infinity,
                            height: Get.width * .75,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Column(
                              children: [
                                // "Select Frequency" Text
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0, bottom: 20.0),
                                      child: Text('Select Frequency',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 30.0),
                                  // Row 1 buttons
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          selectedFrequency = -1;

                                          state(() {});
                                        },
                                        // "Once Button"
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: selectedFrequency == -1
                                                ? Theme.of(context).primaryColor
                                                : Colors.black.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Once",
                                              style: TextStyle(
                                                  color: selectedFrequency != -1
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          selectedFrequency = 0;

                                          state(() {});
                                        },
                                        // "Daily Button"
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: selectedFrequency == 0
                                                ? Theme.of(context).primaryColor
                                                : Colors.black.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Daily",
                                              style: TextStyle(
                                                  color: selectedFrequency != 0
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          state(() {
                                            selectedFrequency = 1;
                                          });
                                        },
                                        // "Weekly" Button
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedFrequency == 1
                                                ? Theme.of(context).primaryColor
                                                : Colors.black.withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Weekly",
                                              style: TextStyle(
                                                  color: selectedFrequency != 1
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 10,
                                            ),
                                    ],
                                  ),
                                ),

                                // Row 2 buttons
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          state(() {
                                            selectedFrequency = 2;
                                          });
                                        },
                                        // "Monthly" Button
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedFrequency == 2
                                                ? Theme.of(context).primaryColor
                                                : Colors.black.withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Monthly",
                                              style: TextStyle(
                                                  color: selectedFrequency != 2
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                      Expanded(
                                          child: InkWell(
                                        // "Yearly" Button
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedFrequency == 3
                                                ? Theme.of(context).primaryColor
                                                : Colors.black.withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Yearly",
                                              style: TextStyle(
                                                  color: selectedFrequency != 3
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          state(() {
                                            selectedFrequency = 3;
                                          });
                                        },
                                      )),
                                      selectedFrequency == 10
                                          ? Container()
                                          : const SizedBox(
                                              width: 5,
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                // Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                        minWidth: Get.width * 0.8,
                                        onPressed: () {
                                          frequencyEventController.text =
                                              selectedFrequency == -1
                                                  ? 'Once'
                                                  : selectedFrequency == 0
                                                      ? 'Daily'
                                                      : selectedFrequency == 1
                                                          ? 'Weekly'
                                                          : selectedFrequency ==
                                                                  2
                                                              ? 'Monthly'
                                                              : 'Yearly';
                                          Get.back();
                                        },
                                        child: Text(
                                          "Select",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: Theme.of(context).primaryColor)
                                  ],
                                ),
                              ],
                            ),
                          );
                        }));
                      },
                      validator: (String? input) {
                        if (input!.isEmpty) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event frequency is required!');
                          return '';
                        }
                        return null;
                      },
                      controller: frequencyEventController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red.shade400, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        hintStyle: TextStyle(
                          color: AppColors.genderTextColor,
                        ),
                        hintText: 'Frequency of event',
                        prefixIcon: Icon(Icons.event_repeat_rounded),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.0),
                        // ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Start Time / End Time
                  Row(
                    children: [
                      Expanded(
                        child: iconTitleContainer(
                            height: 45,
                            icon: const Icon(Icons.access_time_rounded),
                            text: 'Start Time',
                            controller: startTimeController,
                            isReadOnly: true,
                            validator: (input) {},
                            onPress: () {
                              startTimeMethod(context);
                            }),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: iconTitleContainer(
                            height: 45,
                            icon: const Icon(Icons.access_time_rounded),
                            text: 'End Time',
                            isReadOnly: true,
                            controller: endTimeController,
                            validator: (input) {},
                            onPress: () {
                              endTimeMethod(context);
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Event Description
                  Row(
                    children: [
                      myText(
                          text: 'Event Description',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Event description text box
                  Container(
                    height: 149,
                    child: TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      validator: (input) {
                        if (input!.isEmpty) {
                          showSnackBar(context, Colors.red.shade400,
                              'Event description is required!');
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red.shade400, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        hintStyle: TextStyle(
                          color: AppColors.genderTextColor,
                        ),
                        hintText: 'Describe the event...',
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.0),
                        // ),
                      ),
                    ),
                  ),

                  // Event Type Header
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        myText(
                          text: 'Event Type',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Open vs Closed info button
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.red.shade400),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                // title: Center(child: Text('Open or Closed?')),
                                content: Text(
                                  'Open means your guests can invite others. Closed means they can\'t.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

// Dropdown Box Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: AppColors.genderTextColor),
                        ),
                        // decoration: BoxDecoration(
                        //
                        //   // borderRadius: BorderRadius.circular(8),
                        //    border: Border(
                        //         bottom: BorderSide(color: Colors.black.withOpacity(0.8),width: 0.6)
                        //     )
                        //
                        // ),

                        // Event type dropdown
                        child: DropdownButton(
                          isExpanded: true,
                          underline: Container(),
                          //borderRadius: BorderRadius.circular(10),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          elevation: 16,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          value: accessModifier,
                          onChanged: (String? newValue) {
                            setState(
                              () {
                                accessModifier = newValue!;
                              },
                            );
                          },
                          items: closeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Event Price
                      iconTitleContainer(
                          icon: const Icon(Icons.monetization_on_outlined),
                          text: 'Price',
                          type: TextInputType.number,
                          height: 45,
                          controller: priceController,
                          onPress: () {},
                          validator: (String input) {
                            if (input.isEmpty) {
                              showSnackBar(context, Colors.red.shade400,
                                  'Event price is required!');
                              return '';
                            }
                          })
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),

// Create Event Button (isCreatingEvent.value -> Elevated Button shows either way)
                  Obx(
                    () => isCreatingEvent.value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Container(
                              height: 42,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Create Event',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          )
                        // if isCreatingEvent != true -> show elevated button
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Container(
                              height: 42,
                              width: double.infinity,
                              // Create Button
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (media.isEmpty) {
                                      showSnackBar(context, Colors.red.shade400,
                                          'Please upload event media!');

                                      return;
                                    }

                                    if (tagsController.text.isEmpty) {
                                      showSnackBar(context, Colors.red.shade400,
                                          'Event tags are required!');

                                      return;
                                    }
                                    // Show dialog box - "creating event" with circle indicator
                                    showDialog(
                                      context: context,
                                      builder: (context) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AlertDialog(
                                              title: Center(
                                                  child: Text(
                                                'Creating Event',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )),
                                              content: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10, top: 10),
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                    // isCreatingEvent == true -> creating event is in progress
                                    isCreatingEvent(true);

                                    // Data Controller
                                    DataController dataController =
                                        Get.put(DataController());

                                    if (media.isNotEmpty) {
                                      for (int i = 0; i < media.length; i++) {
                                        if (media[i].isVideo!) {
                                          /// If video -> then first upload video file and then upload thumbnail and store it in the map
                                          // Upload Thumbnail URL to Firebase
                                          String thumbnailUrl =
                                              // Data Controller
                                              await dataController
                                                  .uploadThumbnailToFirebase(
                                                      media[i].thumbnail!);
                                          // Upload Video URL to Firebase
                                          String videoUrl = await dataController
                                              .uploadImageToFirebase(
                                                  media[i].video!);

                                          mediaUrls.add({
                                            'url': videoUrl,
                                            'thumbnail': thumbnailUrl,
                                            'isImage': false
                                          });
                                        } else {
                                          /// just upload image
                                          // Upload Image URL to Firebase
                                          String imageUrl = await dataController
                                              .uploadImageToFirebase(
                                                  media[i].image!);
                                          // Media URLs
                                          mediaUrls.add({
                                            'url': imageUrl,
                                            'isImage': true
                                          });
                                        }
                                      }
                                    }
                                    // Tags
                                    List<String> tags =
                                        tagsController.text.split(',');

                                    // Event Information Saved to Database as "eventData"
                                    // Each field is pulling the info from respective controllers
                                    Map<String, dynamic> eventData = {
                                      'event': eventType,
                                      'event_name': titleController.text,
                                      'location': locationController.text,
                                      'date':
                                          '${date!.day}-${date!.month}-${date!.year}',
                                      'start_time': startTimeController.text,
                                      'end_time': endTimeController.text,
                                      'max_entries': int.parse(maxEntries.text),
                                      'frequency_of_event':
                                          frequencyEventController.text,
                                      'description': descriptionController.text,
                                      'who_can_invite': accessModifier,
                                      'joined': [
                                        FirebaseAuth.instance.currentUser!.uid
                                      ],
                                      'price': priceController.text,
                                      'media':
                                          mediaUrls, // pulling form mediaURLs
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tags': tags, // pulling from tags
                                      'inviter': [
                                        FirebaseAuth.instance.currentUser!.uid
                                      ]
                                    };
                                    // Create Event in Firebase
                                    await dataController
                                        .createEvent(eventData)
                                        .then((value) {
                                      print("Event Created!");
                                      isCreatingEvent(false);
                                      resetControllers();

                                      // Once event is created, go back to Home Page (Bottom NavBarView)
                                      Get.to(() => BottomNavBarView(),
                                          transition: Transition.noTransition,
                                          duration: const Duration(
                                              milliseconds: 300));
                                    });
                                  },
                                  child: const Text('Create Event',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Get Image Dialog
  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {
      media.add(EventMediaModel(
          image: File(image.path), video: null, isVideo: false));
    }

    setState(() {});
    Navigator.pop(context);
  }

// Get Video Dialog
  getVideoDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(
      source: source,
    );

    if (video != null) {
      // media.add(File(image.path));

      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      media.add(EventMediaModel(
          thumbnail: uint8list!, video: File(video.path), isVideo: true));
      // thumbnail.add(uint8list!);
      //
      // isImage.add(false);
    }

    // print(thumbnail.first.path);
    setState(() {});

    Navigator.pop(context);
  }

// "Choose Media Type" Dialog Box
  void mediaDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Choose Media Type",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, true);
                    },
                    icon: const Icon(Icons.image, size: 40)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, false);
                    },
                    icon:
                        const Icon(Icons.slow_motion_video_outlined, size: 40)),
              ],
            ),
          );
        },
        context: context);
  }

// "Choose Source" Dialog Box
  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("Choose Source",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                      } else {
                        getVideoDialog(ImageSource.gallery);
                      }
                    },
                    icon: const Icon(Icons.image, size: 40)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      } else {
                        getVideoDialog(ImageSource.camera);
                      }
                    },
                    icon: const Icon(Icons.camera_alt, size: 40)),
              ],
            ),
          );
        },
        context: context);
  }
}
