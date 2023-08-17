import 'package:flutter/material.dart';
import 'package:gathr_app/pages/reset_password_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(const ResetViaEmail(),
              transition: Transition.noTransition,
              duration: const Duration(milliseconds: 100));
        },

        // Forgot Password?
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
