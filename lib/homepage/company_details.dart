import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp/config/config_media.dart';

class CompanyDetails extends StatefulWidget {
  _CompanyDetails createState() => _CompanyDetails();
}

class _CompanyDetails extends State<CompanyDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: Config.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 7,
          ),
          Card(
            elevation: 5,
            color: Color(0xffFDEECE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: Config.screenWidth / 2 + 10,
              width: Config.screenWidth - 20,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage("image/logo2.png"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Color(0xffFDEECE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: Config.screenWidth / 4,
              width: Config.screenWidth - 20,
              padding: EdgeInsets.all(13),
              child: Column(
                children: <Widget>[
                  Text(
                    "Register with POG and avail spare parts and mechanic where ever you wish",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Marmelad",
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Color(0xffFDEECE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: Config.screenWidth / 4,
              width: Config.screenWidth - 20,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Is your vehicle Broke down ?\nchoose Issue from quick access bar below",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Marmelad",
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Card(
            elevation: 5,
            color: Color(0xffFDEECE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: Config.screenWidth / 4,
              width: Config.screenWidth - 20,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Be a part of us and avail exciting offers and services",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Marmelad",
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
