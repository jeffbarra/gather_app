import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gathr_app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import '../services/payment_service.dart';
import '../utils/app_colors.dart';
import '../widgets/widgets.dart';
import 'auth/login.dart';

class CheckOutPage extends StatefulWidget {
  DocumentSnapshot? eventDoc;

  CheckOutPage(this.eventDoc);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
// Auth Controller
  AuthController authController = AuthController();

// Radio Buttons
  int selectedRadio = 0;

  bool radioButtonPushedTwo = false;
  bool radioButtonPushedThree = false;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
  }

// Event Image
  String eventImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      List media = widget.eventDoc!.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Get.to(() => LoginPage());
            },
          )
        ],
        title: Text(
          'Check Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

// Body
      body: SingleChildScrollView(
        child: Container(
          // height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Chosen Event Tile
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Event Image
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(eventImage))),
                      ),
                      // // Get Event Name
                      myText(
                        text: widget.eventDoc!.get('event_name'),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      // remove item icon
                      const Icon(Icons.close_rounded),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.04,
              ),

              // Payment Method
              myText(
                text: 'Payment Method',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Payment Options Area
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        child: const Icon(Icons.credit_card),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // add credit card
                      myText(
                        text: 'Add Credit Card',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Radio(
                    value: 0,
                    groupValue: selectedRadio,
                    onChanged: (int? value) {
                      setState(() {
                        setSelectedRadio(value!);
                        radioButtonPushedTwo = false;
                        radioButtonPushedThree = false;
                      });
                    },
                    activeColor: Colors.red.shade400,
                  ),
                ],
              ),
              numberTextField(text: 'Card Number'),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: EdgeInsets.only(
                        bottom: Get.height * 0.02,
                      ),
                      child: TextFormField(
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Expiration date',
                          contentPadding:
                              const EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.04,
                  ),
                  Expanded(child: numberTextField(text: 'Security Code'))
                ],
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                children: [
                  myText(
                    text: 'Other Payment Options',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Radio Button 1
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // PayPal Icon Container
              Container(
                decoration: BoxDecoration(
                  color: radioButtonPushedTwo
                      ? Colors.red.shade400.withOpacity(0.2)
                      : Colors.white,
                  border: Border.all(
                      color: radioButtonPushedTwo
                          ? Colors.grey.shade400
                          : Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // PayPal Icon
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 40,
                        child: const Icon(Icons.paypal_rounded)),
                    myText(
                      text: 'Paypal',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() {
                          setSelectedRadio(value!);
                          radioButtonPushedTwo = true;
                          radioButtonPushedThree = false;
                        });
                      },
                      activeColor: Colors.red.shade400,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Stripe Icon Container
              Container(
                decoration: BoxDecoration(
                  color: radioButtonPushedThree
                      ? Colors.red.shade400.withOpacity(0.2)
                      : Colors.white,
                  border: Border.all(
                      color: radioButtonPushedThree
                          ? Colors.grey.shade400
                          : Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // Stripe icon
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Image.asset(
                          'lib/assets/images/apple_pay.png',
                        ),
                      ),
                    ),
                    myText(
                      text: 'Apple Pay',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Radio(
                      value: 3,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() {
                          setSelectedRadio(value!);
                          radioButtonPushedTwo = false;
                          radioButtonPushedThree = true;
                        });
                      },
                      activeColor: Colors.red.shade400,
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Event Fee Text
              Row(
                children: [
                  myText(
                    text: 'Event Price',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  // Event Fee
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: myText(
                      text: '\$${widget.eventDoc!.get('price')}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Event Fee Text
              Row(
                children: [
                  myText(
                    text: 'Event Fee',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  // Event Fee
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: myText(
                      text: '\$2',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              // Total Text
              Row(
                children: [
                  myText(
                    text: 'Total',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const Spacer(),

                  // Total Price
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: myText(
                      text: '\$${int.parse(widget.eventDoc!.get('price')) + 2}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),

              // Book Now Button
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // // if Stripe button (3) is selected
                    // if (selectedRadio == 3) {
                    //   makePayment(context,
                    //       amount:
                    //           '${int.parse(widget.eventDoc!.get('price')) + 2}',
                    //       eventId: widget.eventDoc!.id);
                    // }
                  },
                  child: const Text(
                    'Join Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
