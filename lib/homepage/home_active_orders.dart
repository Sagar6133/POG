import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/config/config_media.dart';
import 'package:otp/config/session_storage.dart';
import 'package:otp/homepage/company_details.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeActiveAlarm extends StatefulWidget {
  @override
  _HomeActiveAlarm createState() => _HomeActiveAlarm();
}

class _HomeActiveAlarm extends State<HomeActiveAlarm> {
  var _ownerPhoneNumber;
  bool isLoading = false;
  Razorpay razorPay;
  String documentId;
  var dbref = FirebaseFirestore.instance.collection("alarms");
  String key;
  double ammount;
  @override
  void initState() {
    super.initState();
    Storage()
        .getData("ownerContactNumber")
        .then((value) => _ownerPhoneNumber = value);
    super.initState();

    razorPay = new Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    setState(() {
      isLoading = false;
    });
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Storage().setData("uId", user.uid);
      Storage().setData("ownerContactNumber", user.phoneNumber);
      _ownerPhoneNumber = user.phoneNumber;
    } else if (Storage().getData("uId") != null) {
      _ownerPhoneNumber = user.phoneNumber;
    }
    FirebaseFirestore.instance
        .collection("PaymentKey")
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        setState(() {
          setState(() {
            key = element.data()["key"];
          });
        });
      });
    });
  }

  void openCheakOut(double amount) async {
    var options = {
      'key': key,
      'amount': amount * 100,
      'name': 'POG',
      'description': 'POG Payment',
      'prefil': {'contact': _ownerPhoneNumber, 'email': ''},
      'external': ['paytm', 'phonepay']
    };
    try {
      razorPay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      debugPrint(e);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse resp) {
    Fluttertoast.showToast(msg: "External Wallet " + resp.walletName);
  }

  void _handlePaymentError(PaymentFailureResponse resp) {
    Fluttertoast.showToast(
        msg: "Error: " + resp.code.toString() + "  .  " + resp.message);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse resp) {
    dbref
        .doc(documentId)
        .update({"isPaid": true, "paymentId": resp.paymentId}).then((value) {
      Fluttertoast.showToast(msg: "Successful payment " + resp.paymentId);
    });
    Map<String, dynamic> paymentId = {
      "alarmDocumentId": documentId,
      "paymentId": resp.paymentId,
      "ownerNumber": _ownerPhoneNumber,
      "ammount": ammount,
      "timeStamp": new DateTime.now().toString(),
    };
    FirebaseFirestore.instance.collection("UserPaymentHistroy").add(paymentId);
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("alarms")
          .where("ownerNumber", isEqualTo: _ownerPhoneNumber)
          .where("isPaid", isEqualTo: false)
          .where("finalPaid", isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // ignore: unrelated_type_equality_checks
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xffdaa520),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {}
        if (snapshot.hasError)
          return Center(
            child: Text("Some error came"),
          );
        if (!snapshot.hasData || !snapshot.data.docs.isNotEmpty) {
          return CompanyDetails();
        } else {
          return ListView(
            children: snapshot.data.docs.map((document) {
              return document.data()['ammountAssigned']
                  ? Column(
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
                                  "Nearest Location :  " +
                                      document.data()['nearestLocation'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //  fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Exart Location :  " +
                                      document.data()['exartLocation'],
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
                                      document.data()['problemOfTheVehicle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //  fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Vehicle Number :  " +
                                      document.data()['vehicleNumber'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    // fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Driver's Name :  " +
                                      document.data()['nameOfTheDriver'],
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
                                      document.data()['driverContactNumber'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    // fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Created Date :  " +
                                      document.data()['vehicleType'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Ammout : " +
                                      document
                                          .data()['amountToBePaid']
                                          .toDouble()
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Spare Parts: " +
                                      document.data()['spearParts'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                  height: 20,
                                ),
                                RaisedButton(
                                  child: Text(
                                    "Pay",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Color(0xffdaa520),
                                  onPressed: () async {
                                    print(document
                                        .data()['amountToBePaid']
                                        .toDouble());
                                    double d = document
                                        .data()['amountToBePaid']
                                        .toDouble();
                                    documentId = document.id;
                                    setState(() {
                                      ammount = d;
                                    });
                                    openCheakOut(d);
                                  },
                                )
                              ],
                            ),
                          ),
                          elevation: 10,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: Config.screenWidth,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Exart Location :  " +
                                      document.data()['exartLocation'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //  fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Nearest Location :  " +
                                      document.data()['nearestLocation'],
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
                                      document.data()['problemOfTheVehicle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //  fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Vehicle Number :  " +
                                      document.data()['vehicleNumber'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    // fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Driver's Name :  " +
                                      document.data()['nameOfTheDriver'],
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
                                      document.data()['driverContactNumber'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    // fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Created Date :  " +
                                      document.data()['vehicleType'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Ammout : " +
                                      document
                                          .data()['amountToBePaid']
                                          .toDouble()
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Spare Parts: " +
                                      document.data()['spearParts'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Marmelad",
                                    //fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                              ],
                            ),
                          ),
                          elevation: 10,
                        ),
                      ],
                    );
            }).toList(),
          );
        }
      },
    );
  }
}
