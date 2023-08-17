import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

final textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  // Focused Border
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
  ),
  // Enabled Border
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
  ),
  // Error Border
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
  ),
);

// Snack Bar - message screen that pops up when email is already taken
void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: Duration(milliseconds: 1000),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

// My Text
Widget myText({text, style, textAlign}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

// Icon with Title
Widget iconWithTitle({text, Function? func, bool? isShow = true}) {
  return Row(
    children: [
      !isShow!
          ? Container()
          : Expanded(
              flex: 0,
              child: InkWell(
                onTap: () {
                  func!();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: Get.width * 0.02,
                    top: Get.height * 0.08,
                    bottom: Get.height * 0.02,
                  ),
                  // alignment: Alignment.center,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
      Expanded(
        flex: 6,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: Get.height * 0.056,
            // left: Get.width * 0.26,
          ),
          child: myText(
            text: text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const Expanded(
        flex: 1,
        child: Text(''),
      )
    ],
  );
}

// Elevated Button
Widget elevatedButton({text, Function? onpress}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
    ),
    onPressed: () {
      onpress!();
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

// Text Field
Widget numberTextField(
    {text,
    TextEditingController? controller,
    Function? validator,
    TextInputType inputType = TextInputType.number}) {
  return Container(
    height: 48,
    margin: EdgeInsets.only(bottom: Get.height * 0.02),
    child: TextFormField(
      keyboardType: inputType,
      controller: controller,
      validator: (input) => validator!(input),
      decoration: InputDecoration(
          hintText: text,
          errorStyle: const TextStyle(fontSize: 0),
          contentPadding: const EdgeInsets.only(top: 10, left: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget userProfile({title, path, style}) {
  return Row(
    children: [
      path.toString().isEmpty
          ? Container(
              width: 24,
              height: 24,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            )
          : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(path), fit: BoxFit.fill)),
            ),
      SizedBox(
        width: 10,
      ),
      myText(text: title, style: style)
    ],
  );
}

// My Text Field
Widget myTextField(
    {text,
    Icon? icon,
    bool,
    TextEditingController? controller,
    Function? validator}) {
  return Container(
    height: 45,
    child: TextFormField(
      cursorColor: Colors.red.shade400,
      validator: (input) => validator!(input),
      obscureText: bool,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
        ),
        contentPadding: const EdgeInsets.only(top: 5),
        errorStyle: const TextStyle(fontSize: 0),
        hintStyle: TextStyle(
          color: AppColors.genderTextColor,
        ),
        hintText: text,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

// Icon Title Container
Widget iconTitleContainer(
    {text,
    Icon? icon,
    Function? onPress,
    bool isReadOnly = false,
    TextInputType type = TextInputType.text,
    TextEditingController? controller,
    Function? validator,
    double width = 150,
    double height = 40}) {
  return Container(
    // padding: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(width: 0.1, color: AppColors.genderTextColor),
    ),
    width: width,
    height: height,
    child: TextFormField(
      validator: (String? input) => validator!(input!),
      controller: controller,

      keyboardType: type,
      readOnly: isReadOnly,
      onTap: () {
        onPress!();
      },
      // style: TextStyle(
      //   fontSize: 16,
      //   fontWeight: FontWeight.w400,
      //   color: AppColors.genderTextColor,
      // ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
        ),
        contentPadding: const EdgeInsets.only(top: 5),
        errorStyle: const TextStyle(fontSize: 0),
        hintStyle: TextStyle(
          color: AppColors.genderTextColor,
        ),
        hintText: text,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
