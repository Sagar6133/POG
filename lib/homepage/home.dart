import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp/CustomerRegistration/register_with_phone.dart';
import 'package:otp/config/config_media.dart';
import 'package:otp/config/session_storage.dart';
import 'package:otp/homepage/home_active_orders.dart';
import 'package:otp/homepage/issue_registration.dart';
import 'package:otp/homepage/order_history.dart';
import 'package:otp/homepage/pog_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  bool isLoading = false;
  int _currentIndex = 0;
  final tab = [HomeActiveAlarm(), OrderHistory(), RaiseIssue(), PogUser()];
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return isLoading
        ? CircularProgressIndicator(backgroundColor: Color(0xffdaa520))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "POG",
                style: TextStyle(
                  fontFamily: "Marmelad",
                  fontSize: 20,
                  color: Color(0xffdaa520),
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  icon: IconButton(
                    icon: Icon(
                      Icons.adjust,
                      color: Color(0xffdaa520),
                    ),
                    iconSize: 30,
                    onPressed: () {
                      Storage().clear();
                      FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAppOne()),
                              (route) => false));
                    },
                  ),
                ),
              ],
            ),
            body: tab[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xffdaa520),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              currentIndex:
                  _currentIndex, // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text('Home'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), title: Text('Order Histroy')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.report_problem), title: Text('Issue')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('User'))
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
  }

  Future<void> clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
