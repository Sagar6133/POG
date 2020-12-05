import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/CustomerRegistration/register_with_phone.dart';
import 'package:otp/config/config_media.dart';
import 'package:otp/homepage/home.dart';

class MyApp extends StatefulWidget {
  _CreateSpalsh createState() => _CreateSpalsh();
}

class _CreateSpalsh extends State<MyApp> {
  bool _isLoading = false;
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    startTime();
  }

  void navigationPage() {
    setState(() {
      _isLoading = true;
    });
    setData();
  }

  Future<void> setData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          if (FirebaseAuth.instance.currentUser.uid != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
        } catch (e) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyAppOne()));
        }
      }
    } on SocketException catch (_) {
      _isLoading = false;
      Fluttertoast.showToast(msg: "No Internet Connection");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  verification() {
    print(FirebaseAuth.instance.currentUser.uid);
    Fluttertoast.showToast(msg: FirebaseAuth.instance.currentUser.uid);
    Fluttertoast.showToast(msg: FirebaseAuth.instance.currentUser.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return _isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xffdaa520),
                strokeWidth: 5,
              ),
            ),
          )
        : Scaffold(
            body: Container(
              width: Config.screenWidth,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.white12,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Config.blockSizeVertical * 12.50,
                    ),
                    cAvatar(),
                    Text(
                      "POG",
                      style: Theme.of(context).textTheme.headline1.apply(
                            fontFamily: "Marmelad",
                            color: Colors.black87,
                            fontWeightDelta: 3,
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                        backgroundColor: Color(0xffdaa520)),
                  ],
                ),
              ),
            ),
          );
  }

  cAvatar() {
    return CircleAvatar(
      backgroundColor: Color(0xffefefcd),
      radius: 100,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Image.asset("image/logo.png"),
      ),
    );
  }
}
