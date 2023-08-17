import 'package:flutter/material.dart';

class InviteGuests extends StatefulWidget {
  const InviteGuests({super.key});

  @override
  State<InviteGuests> createState() => _InviteGuestsState();
}

class _InviteGuestsState extends State<InviteGuests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Invite Others Page'),
    ));
  }
}
