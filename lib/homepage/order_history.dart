import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp/config/config_media.dart';
import 'package:otp/config/session_storage.dart';
import 'package:otp/homepage/company_details.dart';
import 'package:otp/models/alarm.dart';

// ignore: must_be_immutable
class OrderHistory extends StatefulWidget {
  @override
  _OrderHistory createState() => _OrderHistory();
}

class _OrderHistory extends State<OrderHistory> {
  String _ownerPhoneNumber;
  @override
  void initState() {
    super.initState();
    Storage().getData("ownerContactNumber").then((value) {
      setState(() {
        _ownerPhoneNumber = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("alarms")
              .where("ownerNumber", isEqualTo: _ownerPhoneNumber)
              .where("isPaid", isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffdaa520),
                ),
              );
            }
            if (snapshot.hasError)
              return Center(
                child: Text("Some error came"),
              );
            if (!snapshot.hasData || !snapshot.data.docs.isNotEmpty) {
              return CompanyDetails();
            } else
              return ListView(
                children: snapshot.data.docs.map((document) {
                  AlarmList alarmList = AlarmList(
                      document.data()['nearestLocation'],
                      document.data()['problemOfTheVehicle'],
                      document.data()['vehicleNumber'],
                      document.data()['nameOfTheDriver'],
                      document.data()['driverContactNumber'],
                      document.data()['vehicleType'],
                      document.data()['ownerNumber'],
                      document.data()['isPaid'],
                      document.data()['createdDate'],
                      document.data()['amountToBePaid'].toDouble(),
                      document.data()['ammountAssigned'],
                      document.data()['paymentId'],
                      document.data()['exartLocation']);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          width: Config.screenWidth,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Neartest Location :  " +
                                    alarmList.selectedNeartestLocation,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Problem Of TheVehicle :  " +
                                    alarmList.problemOfTheVehicle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Vehicle Number :  " + alarmList.vehicleNumber,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  // fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Driver Name :  " + alarmList.nameOfTheDriver,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  // fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Driver's Contact Number :  " +
                                    alarmList.driverContactNumber,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  // fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Date :  " + alarmList.createdDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Ammout Paid: " +
                                    alarmList.amountToBePaid.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Payment numbers : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("UserPaymentHistroy")
                                      .where("alarmDocumentId",
                                          isEqualTo: document.id)
                                      .where("ownerNumber",
                                          isEqualTo: _ownerPhoneNumber)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return Center(
                                        child: Text("Some Error Came"),
                                      );
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xffdaa520),
                                        ),
                                      );
                                    }
                                    return DropdownButton(
                                      items: snapshot.data.docs.map((document) {
                                        return DropdownMenuItem<String>(
                                          value: document.data()["paymentId"],
                                          child: Text(
                                              document.data()["paymentId"]),
                                        );
                                      }).toList(),
                                      onChanged: (String val) {
                                        setState(() {});
                                      },
                                      hint: Text('paymentid'),
                                    );
                                  }),
                              Text(
                                "Towing: " + document.data()['towing'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Marmelad",
                                  //fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        elevation: 10,
                      ),
                    ],
                  );
                }).toList(),
              );
          }),
    );
  }
}
