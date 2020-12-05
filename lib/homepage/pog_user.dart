import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp/config/session_storage.dart';

class PogUser extends StatefulWidget {
  _User createState() => _User();
}

class _User extends State<PogUser> {
  String ownerNumber;

  @override
  void initState() {
    super.initState();
    Storage().getData("ownerContactNumber").then((value) {
      setState(() {
        ownerNumber = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
            ),
            Text(ownerNumber.toString()),
          ],
        ),
      ),
    );
  }
}
